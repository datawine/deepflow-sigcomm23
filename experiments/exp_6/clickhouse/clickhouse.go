package clickhouse

import (
	"encoding/json"
	"errors"
	"exp6/logger"
	"flag"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"
)

type FlagDict struct {
	helpFlag bool
	apiKey   string
	count    int
	output   string
	panelURL string
	random   bool
}

const helpMessage = `
Usage:
  exp6 clickhouse [options] <panel URL>

Options:
  --h, -help                  Show help.
  --api-key <API key>         API Key.
  --count <count>             Count. (default: 100)
  --output <output file>      Output file. Must be a JSON file. (default: result.json)
  --random				      Random query time range. (default: false)`

func Run(args []string) {
	var err error

	// Parse flags.
	flagSet := flag.NewFlagSet("exp6", flag.ExitOnError)
	flagSet.Usage = func() {
		logger.Info(helpMessage)
	}
	var flagDict FlagDict
	flagSet.BoolVar(&flagDict.helpFlag, "help", false, "")
	flagSet.BoolVar(&flagDict.helpFlag, "h", false, "")
	flagSet.StringVar(&flagDict.apiKey, "api-key", "", "")
	flagSet.IntVar(&flagDict.count, "count", 100, "")
	flagSet.StringVar(&flagDict.output, "output", "result.json", "")
	flagSet.BoolVar(&flagDict.random, "random", false, "")
	flagSet.Parse(args)

	// Help flag has the highest priority.
	if flagDict.helpFlag {
		logger.Info(helpMessage)
		return
	}

	// Validate panel URL.
	if len(flagSet.Args()) != 1 {
		logger.Error("Exactly one panel URL must be provided.")
		logger.Info(helpMessage)
		os.Exit(1)
	}
	flagDict.panelURL = flagSet.Args()[0]

	// Check if all flags are provided.
	err = checkFlags(flagDict)
	if err != nil {
		logger.Error(err.Error())
		logger.Info(helpMessage)
		os.Exit(1)
	}

	// Fetch trace list from the Grafana panel.
	logger.Info("Fetching first and last spans from the Grafana panel...")
	firstSpanStartTime, err := fetchFirstOrLastSpanStartTime(flagDict.panelURL, flagDict.apiKey, true)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
	lastSpanStartTime, err := fetchFirstOrLastSpanStartTime(flagDict.panelURL, flagDict.apiKey, false)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

	// Test all span collections.
	testResultList := make([]float64, 0)

	lastReportTime := time.Now()

	queryStartTime := firstSpanStartTime
	queryEndTime := queryStartTime + 900 // 15 minutes

	failedCount := 0

	for i := 0; i < flagDict.count; i++ {
		// Report progress.
		if i == 0 || time.Since(lastReportTime) > time.Second*10 {
			logger.Info("Progress: %d/%d", i+1, flagDict.count)
			lastReportTime = time.Now()
		}

		if flagDict.random {
			queryStartTime = firstSpanStartTime + rand.Intn(lastSpanStartTime-firstSpanStartTime)
			queryEndTime = queryStartTime + 900 // 15 minutes
		}

		// Query span list.
		queryResult, err := fetchSpanInRange(flagDict.panelURL, flagDict.apiKey, queryStartTime, queryEndTime)
		if err != nil {
			logger.Error(err.Error())
			failedCount++
		} else {
			// Calculate test result.
			testResultList = append(testResultList, float64(queryResult.Seconds()))
		}

		if !flagDict.random {
			queryStartTime += 900 // 15 minutes
			queryEndTime += 900
		}
	}

	// Print test result in JSON format.
	resultMap := map[string]interface{}{
		"average":     0,
		"percentile":  []int{},
		"raw_results": testResultList,
		"failed":      failedCount,
		"total":       flagDict.count,
		"failed_rate": float64(failedCount) / float64(flagDict.count),
	}

	// Calculate average.
	var sum float64 = 0
	for _, result := range testResultList {
		sum += result
	}
	if len(testResultList) > 0 {
		resultMap["average"] = sum / float64(len(testResultList))
	} else {
		resultMap["average"] = 0
	}

	// Calculate percentile.
	sort.Float64s(testResultList)
	percentileList := make([]float64, 100)
	for i := 0; i < 100; i++ {
		percentileList[i] = testResultList[int(float64(len(testResultList))*float64(i)/100)]
	}
	resultMap["percentile"] = percentileList

	// Write result to file.
	resultJSON, err := json.Marshal(resultMap)
	if err != nil {
		logger.Error("failed to marshal result to JSON: " + err.Error())
		os.Exit(1)
	}
	err = os.WriteFile(flagDict.output, resultJSON, 0644)
	if err != nil {
		logger.Error("failed to write result to file: " + err.Error())
		os.Exit(1)
	}

	logger.Info("Test finished. Result written to %s.", flagDict.output)

	// Print test result.
	logger.Info("Average (one query with 100 spans): %fs, 1%%: %fs, 25%%: %fs, 50%%: %fs, 75%%: %fs, 99%%: %fs", resultMap["average"], percentileList[0], percentileList[24], percentileList[49], percentileList[74], percentileList[99])
}

// checkFLags checks if all flags are provided.
func checkFlags(flagDict FlagDict) error {
	if flagDict.apiKey == "" {
		return errors.New("an API key must be provided")
	}

	if flagDict.count <= 0 {
		return errors.New("a positive count must be provided")
	}

	if !strings.HasSuffix(flagDict.output, ".json") {
		return errors.New("output file must a JSON file")
	}

	if !strings.HasPrefix(flagDict.panelURL, "http://") && !strings.HasPrefix(flagDict.panelURL, "https://") {
		return errors.New("host URL must start with http:// or https://")
	}

	return nil
}

// convertTimeToTimestamp converts time from format "2021-07-01 00:00:00.000000" to timestamp.
func convertTimeToTimestamp(timeString string) (int, error) {
	layout := "2006-01-02 15:04:05.000000"
	t, err := time.Parse(layout, timeString)
	if err != nil {
		return 0, errors.New("failed to convert time to timestamp: " + err.Error())
	}
	return int(t.UnixMicro()), nil
}

// fetchFirstOrLastSpanStartTime fetches the start time of the first or last span from the Grafana panel.
func fetchFirstOrLastSpanStartTime(panelURL string, apiKey string, isFirst bool) (int, error) {
	// Create request
	order := "ASC"
	if !isFirst {
		order = "DESC"
	}
	postContent := fmt.Sprintf("db=flow_log&sql=SELECT toString(start_time) AS `start_time`, toString(end_time) as `end_time` FROM l7_flow_log WHERE tap_port_type IN (7,8) AND (pod_ns_0 = 'deepflow-ebpf-istio-demo' OR pod_ns_1 = 'deepflow-ebpf-istio-demo') ORDER BY `start_time` %s LIMIT 1", order)

	// Create request
	req, err := http.NewRequest("POST", strings.TrimSuffix(panelURL, "/")+"/api/datasources/proxy/1/noauth/v1/query/", strings.NewReader(postContent))
	if err != nil {
		return 0, errors.New("failed to create request: " + err.Error())
	}
	req.Header.Set("Content-Type", "text/plain")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return 0, errors.New("failed to fetch first span from the Grafana panel: " + err.Error())
	}
	defer resp.Body.Close()

	// Get response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return 0, errors.New("failed to read response body: " + err.Error())
	}

	// Parse response body
	var respJSON map[string]interface{}
	err = json.Unmarshal(body, &respJSON)
	if err != nil {
		return 0, errors.New("failed to parse response body: " + err.Error())
	}
	if respJSON["message"] != nil {
		return 0, errors.New("failed to fetch span list from the Grafana panel: " + respJSON["message"].(string))
	}
	if respJSON["OPT_STATUS"] != "SUCCESS" {
		return 0, errors.New("failed to fetch span list from the Grafana panel: OPT_STATUS=" + respJSON["OPT_STATUS"].(string))
	}
	valueListJSON := respJSON["result"].(map[string]interface{})["values"].([]interface{})
	if len(valueListJSON) == 0 {
		return 0, errors.New("failed to fetch span list from the Grafana panel: no span found")
	}
	startTime, err := convertTimeToTimestamp(valueListJSON[0].([]interface{})[0].(string))
	if err != nil {
		return 0, err
	}

	return startTime, nil
}

// fetchSpanInRange tests the trace and gets the time cost.
// timeStart and timeEnd are in seconds.
// return value: time cost in microseconds.
func fetchSpanInRange(panelURL string, apiKey string, timeStart int, timeEnd int) (time.Duration, error) {
	var err error

	postContent := fmt.Sprintf("db=flow_log&sql=select `response_duration` AS `Response Delay`, resource_gl0_0, resource_gl0_1, ip_0, ip_1, toString(start_time) AS `start_time`, Enum(tap_port_type), Enum(l7_protocol), request_type, request_domain, request_resource, Enum(response_status), response_code, response_exception, trace_id, span_id, server_port, endpoint, toString(_id), resource_gl0_id_0, resource_gl0_id_1 from l7_flow_log where tap_port_type IN (7,8) AND (pod_cluster_id_0!=0 OR pod_cluster_id_1!=0) AND (pod_ns_0='deepflow-ebpf-istio-demo' OR pod_ns_1='deepflow-ebpf-istio-demo') AND (pod_group_id_0!=0 OR pod_group_id_1!=0) AND (chost_id_0!=0 OR chost_id_1!=0) AND trace_id LIKE('*') AND span_id LIKE('*') AND request_resource LIKE('*') AND time>=%d AND time<=%d limit 100", timeStart, timeEnd)

	// Create request
	req, err := http.NewRequest("POST", strings.TrimSuffix(panelURL, "/")+"/api/datasources/proxy/1/noauth/v1/query/?debug=true", strings.NewReader(postContent))
	if err != nil {
		return 0, errors.New("failed to create request: " + err.Error())
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return 0, errors.New("failed to fetch trace list from the Grafana panel: " + err.Error())
	}
	defer resp.Body.Close()

	// Get response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return 0, errors.New("failed to read response body: " + err.Error())
	}

	// Parse response body
	var respJSON map[string]interface{}
	err = json.Unmarshal(body, &respJSON)
	if err != nil {
		return 0, errors.New("failed to parse response body: " + err.Error())
	}
	if respJSON["message"] != nil {
		return 0, errors.New("failed to fetch span list from the Grafana panel: " + respJSON["message"].(string))
	}
	if respJSON["OPT_STATUS"] != "SUCCESS" {
		return 0, errors.New("failed to fetch span list from the Grafana panel: OPT_STATUS=" + respJSON["OPT_STATUS"].(string))
	}
	if respJSON["debug"] == nil {
		return 0, errors.New("failed to fetch debug information from the Grafana panel: debug is nil")
	}
	queryTimeStr := respJSON["debug"].(map[string]interface{})["query_time"].(string) // a string like "0.000s"
	queryTime, err := time.ParseDuration(queryTimeStr)
	if err != nil {
		return 0, errors.New("failed to parse query time: " + err.Error())
	}

	return queryTime, nil
}

package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"exp6/logger"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"
)

type FlagDict struct {
	helpFlag bool
	apiKey   string
	panelURL string
	count    int
	output   string
}

type TraceInfo struct {
	startTime int
	endTime   int
	id        string
}

const helpMessage = `
Usage:
  exp6 --api-key <API Key> --panel-url <Panel URL> --count <Count> --output <Output File> [--help | -h]

Options:
  --h, -help                  Show help.
  --api-key <API Key>         API Key.
  --panel-url <Panel URL>     The Grafana panel URL without path.
  --count <Count>             Count.
  --output <Output File>      Output file (in JSON format).`

func main() {
	if len(os.Args) < 2 {
		logger.Error("No arguments provided.")
		logger.Info(helpMessage)
		os.Exit(1)
	}

	// Parse flags.
	flagSet := flag.NewFlagSet("exp6", flag.ExitOnError)
	flagSet.Usage = func() {
		logger.Info(helpMessage)
	}
	var flagDict FlagDict
	flagSet.BoolVar(&flagDict.helpFlag, "help", false, "")
	flagSet.BoolVar(&flagDict.helpFlag, "h", false, "")
	flagSet.StringVar(&flagDict.apiKey, "api-key", "", "")
	flagSet.StringVar(&flagDict.panelURL, "panel-url", "", "")
	flagSet.IntVar(&flagDict.count, "count", 0, "")
	flagSet.StringVar(&flagDict.output, "output", "", "")
	flagSet.Parse(os.Args[1:])

	// Help flag has the highest priority.
	if flagDict.helpFlag {
		logger.Info(helpMessage)
		return
	}

	var err error

	// Check if all flags are provided.
	err = checkFlags(flagDict)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

	// Fetch trace list from the Grafana panel.
	logger.Info("Fetching trace list from the Grafana panel...")
	traceList, err := fetchTraceList(flagDict.panelURL, flagDict.apiKey, flagDict.count)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

	// Test all traces.
	logger.Info("Testing %d traces...", len(traceList))
	var testResultList []float64
	startTime := time.Now()
	lastReportTime := startTime
	for idx, trace := range traceList {
		if idx == 0 || time.Since(lastReportTime) > 10*time.Second {
			logger.Info("Testing trace %d/%d...", idx+1, len(traceList))
			lastReportTime = time.Now()
		}
		testResult, err := testTrace(flagDict.panelURL, flagDict.apiKey, trace, 0, 999999999999)
		if err != nil {
			logger.Error(err.Error())
			continue
		}
		testResultList = append(testResultList, float64(testResult.Seconds()))
	}

	// Print test result in JSON format.
	resultMap := map[string]interface{}{
		"average":     0,
		"percentile":  []int{},
		"raw_results": testResultList,
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
	logger.Info("Average: %fs, 1%%: %fs, 25%%: %fs, 50%%: %fs, 75%%: %fs, 99%%: %fs", resultMap["average"], percentileList[0], percentileList[24], percentileList[49], percentileList[74], percentileList[99])
	logger.Info("Total time: %s", time.Since(startTime))
}

// checkFLags checks if all flags are provided.
func checkFlags(flagDict FlagDict) error {
	if flagDict.apiKey == "" {
		return errors.New("no API key provided")
	}

	if flagDict.panelURL == "" {
		return errors.New("no host URL provided")
	}
	if !strings.HasPrefix(flagDict.panelURL, "http://") && !strings.HasPrefix(flagDict.panelURL, "https://") {
		return errors.New("host URL must start with http:// or https://")
	}

	if flagDict.count == 0 {
		return errors.New("no count provided")
	}

	if flagDict.output == "" {
		return errors.New("no output file provided")
	}
	if !strings.HasSuffix(flagDict.output, ".json") {
		return errors.New("output file must a JSON file")
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

// fetchTraceList fetches the trace list from the Grafana panel.
func fetchTraceList(panelURL string, apiKey string, count int) ([]TraceInfo, error) {
	postContent := fmt.Sprintf("db=flow_log&sql=SELECT toString(start_time) AS `start_time`, toString(end_time) as `end_time`, toString(_id) FROM l7_flow_log WHERE tap_port_type IN (7,8) AND (pod_ns_0 = 'deepflow-ebpf-istio-demo' OR pod_ns_1 = 'deepflow-ebpf-istio-demo') AND (pod_group_0 = 'loadgenerator' OR pod_group_1 = 'loadgenerator') AND request_resource = '/productpage' ORDER BY `start_time` LIMIT %d", count)

	// Create request
	req, err := http.NewRequest("POST", strings.TrimSuffix(panelURL, "/")+"/api/datasources/proxy/1/noauth/v1/query/", strings.NewReader(postContent))
	if err != nil {
		return nil, errors.New("failed to create request: " + err.Error())
	}
	req.Header.Set("Content-Type", "text/plain")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, errors.New("failed to fetch trace list from the Grafana panel: " + err.Error())
	}
	defer resp.Body.Close()

	// Get response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, errors.New("failed to read response body: " + err.Error())
	}

	// Parse response body
	var respJSON map[string]interface{}
	err = json.Unmarshal(body, &respJSON)
	if err != nil {
		return nil, errors.New("failed to parse response body: " + err.Error())
	}
	if respJSON["message"] != nil {
		return nil, errors.New("failed to fetch trace list from the Grafana panel: " + respJSON["message"].(string))
	}
	if respJSON["OPT_STATUS"] != "SUCCESS" {
		return nil, errors.New("failed to fetch trace list from the Grafana panel: OPT_STATUS=" + respJSON["OPT_STATUS"].(string))
	}
	var traceList []TraceInfo
	for _, value := range respJSON["result"].(map[string]interface{})["values"].([]interface{}) {
		valueList := value.([]interface{})

		startTime, err := convertTimeToTimestamp(valueList[0].(string))
		if err != nil {
			return nil, err
		}

		endTime, err := convertTimeToTimestamp(valueList[1].(string))
		if err != nil {
			return nil, err
		}

		id := valueList[2].(string)

		traceList = append(traceList, TraceInfo{
			startTime: startTime,
			endTime:   endTime,
			id:        id,
		})
	}

	return traceList, nil
}

// testTrace tests the trace and gets the time cost.
// timeStart and timeEnd are in seconds.
// return value: time cost in microseconds.
func testTrace(panelURL string, apiKey string, trace TraceInfo, timeStart int, timeEnd int) (time.Duration, error) {
	var err error

	reqMap := map[string]interface{}{
		"_id":              trace.id,
		"DATABASE":         "flow_log",
		"TABLE":            "l7_flow_log",
		"MAX_ITERATION":    30,
		"NETWORK_DELAY_US": 3000000,
		"time_start":       timeStart,
		"time_end":         timeEnd,
	}
	reqBody, err := json.Marshal(reqMap)
	if err != nil {
		return 0, errors.New("failed to marshal request body: " + err.Error())
	}

	// Create request
	req, err := http.NewRequest("POST", strings.TrimSuffix(panelURL, "/")+"/api/datasources/proxy/1/noauth/v1/query/", bytes.NewReader(reqBody))
	if err != nil {
		return 0, errors.New("failed to create request: " + err.Error())
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	// Calculate time cost
	startTime := time.Now()
	_, err = http.DefaultClient.Do(req)
	if err != nil {
		return 0, errors.New("failed to test trace: " + err.Error())
	}
	timeCost := time.Since(startTime)

	return timeCost, nil
}

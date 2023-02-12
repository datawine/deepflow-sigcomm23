package l7

import (
	"bytes"
	"encoding/json"
	"errors"
	"exp6/logger"
	"flag"
	"io"
	"math"
	"math/rand"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"
)

type FlagDict struct {
	helpFlag  bool
	apiKey    string
	count     int
	output    string
	panelURL  string
	queryTime int
	shuffle   bool
}

type TraceInfo struct {
	startTime int
	endTime   int
	id        string
}

const helpMessage = `
Usage:
  exp6 l7 [options] <panel URL>

Options:
  --h, -help                  Show help.
  --api-key <API key>         API Key.
  --count <count>             Count. (default: 100)
  --output <output file>      Output file. Must be a JSON file. (default: result.json)
  --query-time <query time>   Query time range length in seconds. (default: 900)
  --shuffle				      Shuffle trace list before testing. (default: false)`

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
	flagSet.IntVar(&flagDict.queryTime, "query-time", 900, "")
	flagSet.BoolVar(&flagDict.shuffle, "shuffle", false, "")
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
	logger.Info("Fetching trace list from the Grafana panel...")
	traceList, err := fetchTraceList(flagDict.panelURL, flagDict.apiKey)
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}
	if len(traceList) == 0 {
		logger.Error("No trace found.")
		os.Exit(1)
	}

	// Shuffle trace list if needed.
	if flagDict.shuffle {
		logger.Info("Shuffling trace list...")
		rand.Shuffle(len(traceList), func(i, j int) {
			traceList[i], traceList[j] = traceList[j], traceList[i]
		})
	}

	// Test all traces.
	logger.Info("Testing %d traces...", flagDict.count)
	traceList = traceList[:flagDict.count]

	failedCount := 0

	var testResultList []float64
	startTime := time.Now()
	lastReportTime := startTime
	for idx, trace := range traceList {
		// Report progress every 10 seconds.
		if idx == 0 || time.Since(lastReportTime) > 10*time.Second {
			logger.Info("Testing trace %d/%d...", idx+1, len(traceList))
			lastReportTime = time.Now()
		}

		windowLength := int(math.Max(float64(flagDict.queryTime-(trace.endTime-trace.startTime)), 1)) // The length of the time window to slide.
		startOffset := rand.Intn(windowLength)                                                        // The offset of the start time of the time window.
		endOffset := windowLength - startOffset                                                       // The offset of the end time of the time window.

		// However, to ensure that the test result is accurate, if end time of the trace is after the end time of the period, we should extend the period to the end time of the trace.
		testResult, err := testTrace(flagDict.panelURL, flagDict.apiKey, trace, trace.startTime-startOffset, trace.endTime+endOffset)
		if err != nil {
			logger.Error(err.Error())
			failedCount++
			continue
		}
		testResultList = append(testResultList, float64(testResult.Seconds()))
	}

	// Print test result in JSON format.
	resultMap := map[string]interface{}{
		"average":     0,
		"percentile":  []int{},
		"raw_results": testResultList,
		"failed":      failedCount,
		"total":       len(traceList),
		"failed_rate": float64(failedCount) / float64(len(traceList)),
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
		return errors.New("an API key must be provided")
	}

	if flagDict.count <= 0 {
		return errors.New("a positive count must be provided")
	}

	if !strings.HasSuffix(flagDict.output, ".json") {
		return errors.New("output file must a JSON file")
	}

	if flagDict.queryTime <= 0 {
		return errors.New("a positive query time must be provided")
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

// fetchTraceList fetches the trace list from the Grafana panel.
func fetchTraceList(panelURL string, apiKey string) ([]TraceInfo, error) {
	// Select traces as many as possible (1145141919810 is a quite large number).
	postContent := "db=flow_log&sql=SELECT toString(start_time) AS `start_time`, toString(end_time) as `end_time`, toString(_id) FROM l7_flow_log WHERE tap_port_type IN (7,8) AND (pod_ns_0 = 'deepflow-ebpf-istio-demo' OR pod_ns_1 = 'deepflow-ebpf-istio-demo') AND (pod_group_0 = 'loadgenerator' OR pod_group_1 = 'loadgenerator') AND request_resource = '/productpage' ORDER BY `start_time` LIMIT 1145141919810"

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
	defer req.Body.Close()
	timeCost := time.Since(startTime)

	return timeCost, nil
}

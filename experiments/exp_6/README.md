# Experiment 6 Testing Toolset

This is a toolset for testing the performance of the experiment 6. Two tools are provided: L7 and Clickhouse. L7 tool measures the latency in getting `/api/datasources/proxy/1/trace/v1/stats/querier/L7FlowTracing` file. Clickhouse tool performs queries on spans and collects the `query_time` fields.

## Usage

### L7

You can run `exp6 l7 --help` to see the usage of the L7 tool.

```shell
Usage:
  exp6 l7 [options] <panel URL>

Options:
  --h, -help                  Show help.
  --api-key <API key>         API Key.
  --count <count>             Count. (default: 100)
  --output <output file>      Output file. Must be a JSON file. (default: result.json)
  --query-time <query time>   Query time range length in seconds. (default: 900)
  --shuffle				      Shuffle trace list before testing. (default: false)
```

### Clickhouse

You can run `exp6 clickhouse --help` to see the usage of the Clickhouse tool.

```shell
Usage:
  exp6 clickhouse [options] <panel URL>

Options:
  --h, -help                  Show help.
  --api-key <API key>         API Key.
  --count <count>             Count. (default: 100)
  --output <output file>      Output file. Must be a JSON file. (default: result.json)
  --random				      Random query time range. (default: false)
```
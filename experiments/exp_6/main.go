package main

import (
	"exp6/clickhouse"
	"exp6/l7"
	"exp6/logger"
	"flag"
	"os"
)

type FlagDict struct {
	helpFlag bool
}

const helpMessage = `
Usage:
  exp6 <command> [arguments]
  exp6 [options]

Commands:
  l7	                      Test latency in fetching L7FlowTracing.
  clickhouse                  Fetch query_time from spans.

Options:
  --h, -help                  Show help.`

func main() {
	// Parse flags.
	flagSet := flag.NewFlagSet("exp6", flag.ExitOnError)
	flagSet.Usage = func() {
		logger.Info(helpMessage)
	}
	var flagDict FlagDict
	flagSet.BoolVar(&flagDict.helpFlag, "help", false, "")
	flagSet.BoolVar(&flagDict.helpFlag, "h", false, "")
	flagSet.Parse(os.Args[1:])

	// Help flag has the highest priority.
	if flagDict.helpFlag {
		logger.Info(helpMessage)
		return
	}

	// Parse subcommand.
	if len(os.Args) < 2 {
		logger.Error("No subcommand provided.")
		logger.Info(helpMessage)
		os.Exit(1)
	}
	switch os.Args[1] {
	case "l7":
		l7.Run(os.Args[2:])
	case "clickhouse":
		clickhouse.Run(os.Args[2:])
	default:
		logger.Error("Unknown subcommand.")
		logger.Info(helpMessage)
		os.Exit(1)
	}
}

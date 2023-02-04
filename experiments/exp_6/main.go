package main

import (
	"exp6/logger"
	"flag"
	"os"
)

type FlagDict struct {
	helpFlag bool
	apiKey   string
	url      string
	query    string
	count    int
}

const helpMessage = `
Usage:
  exp6 --api-key <API Key> --url <URL> --query <Query> --count <Count>

Options:
  -h, --help                  Show help.
  --api-key <API Key>         API Key.
  --url <URL>                 URL.
  --query <Query>             Query.
  --count <Count>             Count.`

func main() {
	if len(os.Args) < 2 {
		logger.Error("No arguments provided.")
		logger.Info(helpMessage)
		os.Exit(1)
	}

	// Parse flags
	flagSet := flag.NewFlagSet("exp6", flag.ExitOnError)
	flagSet.Usage = func() {
		logger.Info(helpMessage)
	}
	var flagDict FlagDict
	flagSet.BoolVar(&flagDict.helpFlag, "help", false, "Show help.")
	flagSet.BoolVar(&flagDict.helpFlag, "h", false, "Show help.")
	flagSet.StringVar(&flagDict.apiKey, "api-key", "", "API Key.")
	flagSet.StringVar(&flagDict.url, "url", "", "URL.")
	flagSet.StringVar(&flagDict.query, "query", "", "Query.")
	flagSet.IntVar(&flagDict.count, "count", 0, "Count.")
	flagSet.Parse(os.Args[1:])

	// Help flag has the highest priority
	if flagDict.helpFlag {
		logger.Info(helpMessage)
		return
	}

	checkFlags(flagDict)
}

// checkFLags checks if all flags are provided
func checkFlags(flagDict FlagDict) {
	if flagDict.apiKey == "" {
		logger.Error("No API Key provided.")
		os.Exit(1)
	}
	if flagDict.url == "" {
		logger.Error("No URL provided.")
		os.Exit(1)
	}
	if flagDict.query == "" {
		logger.Error("No Query provided.")
		os.Exit(1)
	}
	if flagDict.count == 0 {
		logger.Error("No Count provided.")
		os.Exit(1)
	}
}

package main

import (
	"log"

	"cmd_demo/cmd"
)

var (
	commitVersion = "0"
	commitCount   = "0"
	version       = "2.1." + commitVersion + "." + commitCount
)

func main() {
	cmd.Version = version
	err := cmd.Execute()
	if err != nil {
		log.Fatalf("cmd.Execute err: %v", err)
	}
}

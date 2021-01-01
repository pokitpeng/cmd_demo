package cmd

import (
	"fmt"

	"github.com/spf13/cobra"

	"cmd_demo/cmd/command"
)

var (
	Version   string
	isVersion *bool
)

var rootCmd = &cobra.Command{
	Use:   "word_conversion",
	Short: "Word conversion tool",
	Run: func(cmd *cobra.Command, args []string) {
		if *isVersion {
			fmt.Println(Version)
		} else {
			_ = cmd.Help()
		}
	},
}

func init() {
	isVersion = rootCmd.Flags().BoolP("version", "v", false, "show version")
	rootCmd.AddCommand(command.WordCmd)
	rootCmd.AddCommand(command.NowTimeCmd)
	rootCmd.AddCommand(command.Json2structCmd)
	rootCmd.AddCommand(command.Sql2structCmd)
}

// Execute ...
func Execute() error {
	return rootCmd.Execute()
}

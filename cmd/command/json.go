package command

import (
	"log"

	"github.com/spf13/cobra"

	"cmd_demo/internal/json2struct"
)

var json string

var Json2structCmd = &cobra.Command{
	Use:   "json",
	Short: "json转结构体",
	Run: func(cmd *cobra.Command, args []string) {
		parser, err := json2struct.NewParser(json)
		if err != nil {
			log.Fatalf("json2struct.NewParser err: %v", err)
		}
		content := parser.Json2Struct()
		log.Printf("输出结果 : %s", content)
	},
}

func init() {
	Json2structCmd.Flags().StringVarP(&json, "json", "j", "", "请输入json字符串")
}

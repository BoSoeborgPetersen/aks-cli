package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var toolsCmd = &c.Command{
	Use:   "tools",
	Short: "Show other tools present",
	Long:  h.Description(`Show other tools present`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		h.Tools()
	},
}

func init() {
	rootCmd.AddCommand(toolsCmd)
}

package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var invokeCmd = &c.Command{
	Use:   "invoke <command>",
	Short: "Execute command in the current cluster",
	Long:  h.Description(`Execute command in the current cluster`),
	Args:  h.RequiredArg("<command>"),
	Run: func(cmd *c.Command, args []string) {
		command := h.StringArg(0)

		h.CheckCurrentCluster()

		h.WriteInfo(h.Format("Invoke '%s'", command))

		h.AzAksCurrentCommand(h.Format("command invoke -c \"%s\"", command))
	},
}

func init() {
	rootCmd.AddCommand(invokeCmd)
}

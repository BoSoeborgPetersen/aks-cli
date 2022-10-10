package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var azCmd = &c.Command{
	Use:   "az <params>",
	Short: "Execute 'az aks -g <group> -n <name> <params>' command with -g and -n filled out",
	Long:  h.Description(`Execute az command with -g and -n filled out`),
	Args:  h.RequiredArg("parameters (<params>)"),
	Run: func(cmd *c.Command, args []string) {
		params := args[0]

		h.CheckCurrentCluster()

		h.WriteInfo(h.Format("az aks -g %s -n %s %s", h.CurrentClusterResourceGroup(), h.CurrentClusterName(), args))

		h.AzAksCurrentCommand(params)
	},
}

func init() {
	rootCmd.AddCommand(azCmd)
}

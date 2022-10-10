package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var versionCmd = &c.Command{
	Use:   "version",
	Short: "Get AKS cluster version",
	Long:  h.Description(`Get AKS cluster version`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Current AKS cluster version")

		h.PrintAzAksCurrentCommandF("show", h.AzAksCommandFlags{Query: "kubernetesVersion", Output: "tsv"})
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}

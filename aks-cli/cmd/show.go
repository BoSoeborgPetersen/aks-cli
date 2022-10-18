package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var showCmd = &c.Command{
	Use:   "show",
	Short: "Show AKS information",
	Long:  h.Description(`Show AKS information`),
	Args:  c.NoArgs,
	Run: func(cmd *c.Command, args []string) {
		query := h.StringFlag("query")

		h.CheckCurrentCluster()

		h.WriteInfo("Show AKS cluster information")

		h.Write(h.AzAksCurrentCommandP("show", h.AzAksFlags{Query: query}))
	},
}

func init() {
	showCmd.Flags().StringP("query", "q", "", "Azure CLI JsonPath Query")
	rootCmd.AddCommand(showCmd)
}

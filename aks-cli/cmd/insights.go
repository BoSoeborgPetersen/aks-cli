package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var InsightsCmd = &c.Command{
	Use:   "insights",
	Short: "AKS insights operations",
	Long:  h.Description(`AKS insights operations`),
}

func init() {
	rootCmd.AddCommand(InsightsCmd)
}

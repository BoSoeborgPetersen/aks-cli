package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var IdentityCmd = &c.Command{
	Use:   "identity",
	Short: "Azure Managed Identity operations",
	Long:  h.Description(`Azure Managed Identity operations`),
}

func init() {
	rootCmd.AddCommand(IdentityCmd)
}

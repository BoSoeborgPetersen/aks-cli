package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var ServicePrincipalCmd = &c.Command{
	Use:   "service-principal",
	Short: "Azure Service Principal operations",
	Long:  h.Description(`Azure Service Principal operations`),
}

func init() {
	rootCmd.AddCommand(ServicePrincipalCmd)
}

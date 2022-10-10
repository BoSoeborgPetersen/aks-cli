package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var RegistryCmd = &c.Command{
	Use:   "registry",
	Short: "Azure Container Registry operations",
	Long:  h.Description(`Azure Container Registry operations`),
}

func init() {
	rootCmd.AddCommand(RegistryCmd)
}

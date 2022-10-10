package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var CertManagerCmd = &c.Command{
	Use:   "cert-manager",
	Short: "Certificate Manager operations",
	Long:  h.Description(`Certificate Manager operations`),
}

func init() {
	rootCmd.AddCommand(CertManagerCmd)
}

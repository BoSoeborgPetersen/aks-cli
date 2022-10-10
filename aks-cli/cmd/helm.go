package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var HelmCmd = &c.Command{
	Use:   "helm",
	Short: "Helm release operations (export/import)",
	Long:  h.Description(`Helm release operations (export/import)`),
}

func init() {
	rootCmd.AddCommand(HelmCmd)
}

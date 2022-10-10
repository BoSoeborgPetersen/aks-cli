package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var VpaCmd = &c.Command{
	Use:   "vpa",
	Short: "VPA operations",
	Long:  h.Description(`Vertical Pod Autoscaler operations`),
}

func init() {
	rootCmd.AddCommand(VpaCmd)
}

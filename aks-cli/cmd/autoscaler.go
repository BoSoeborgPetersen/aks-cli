package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var AutoscalerCmd = &c.Command{
	Use:   "autoscaler",
	Short: "Setup automatic pod or node scaling",
	Long:  h.Description(`Setup automatic pod or node scaling`),
}

func init() {
	rootCmd.AddCommand(AutoscalerCmd)
}

package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var StateCmd = &c.Command{
	Use:   "state",
	Short: "Change default state operations",
	Long:  h.Description(`Change default state operations`),
}

func init() {
	rootCmd.AddCommand(StateCmd)
}

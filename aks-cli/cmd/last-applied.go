package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var LastAppliedCmd = &c.Command{
	Use:   "last-applied",
	Short: "Last-Applied-Config operations",
	Long:  h.Description(`Last-Applied-Config operations`),
}

func init() {
	rootCmd.AddCommand(LastAppliedCmd)
}

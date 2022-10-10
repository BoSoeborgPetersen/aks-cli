package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var ScaleCmd = &c.Command{
	Use:   "scale",
	Short: "Scale operations",
	Long:  h.Description(`Scale operations`),
}

func init() {
	rootCmd.AddCommand(ScaleCmd)
}

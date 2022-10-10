package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var TrafficManagerCmd = &c.Command{
	Use:   "traffic-manager",
	Short: "Azure Traffic Manager operations",
	Long: h.Description(`Azure Traffic Manager operations`),
}

func init() {
	rootCmd.AddCommand(TrafficManagerCmd)
}

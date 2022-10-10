package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var MonitoringCmd = &c.Command{
	Use:   "monitoring",
	Short: "Prometheus and Grafana operations",
	Long:  h.Description(`Prometheus and Grafana operations`),
}

func init() {
	rootCmd.AddCommand(MonitoringCmd)
}

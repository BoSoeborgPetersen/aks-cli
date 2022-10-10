package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var PodCmd = &c.Command{
	Use:   "pod",
	Short: "Kubernetes pod operations",
	Long:  h.Description(`Kubernetes pod operations`),
}

func init() {
	rootCmd.AddCommand(PodCmd)
}

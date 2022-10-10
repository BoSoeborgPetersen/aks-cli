package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var KedaCmd = &c.Command{
	Use:   "keda",
	Short: "Keda (Kubernetes Event-driven Autoscaling) operations",
	Long:  h.Description(`Keda (Kubernetes Event-driven Autoscaling) operations`),
}

func init() {
	rootCmd.AddCommand(KedaCmd)
}

package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var NginxCmd = &c.Command{
	Use:   "nginx",
	Short: "Nginx operations",
	Long:  h.Description(`Nginx operations`),
}

func init() {
	rootCmd.AddCommand(NginxCmd)
}

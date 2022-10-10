package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var KuredCmd = &c.Command{
	Use:   "kured",
	Short: "Kured (KUbernetes REboot Daemon) operations",
	Long:  h.Description(`Kured (KUbernetes REboot Daemon) operations`),
}

func init() {
	rootCmd.AddCommand(KuredCmd)
}

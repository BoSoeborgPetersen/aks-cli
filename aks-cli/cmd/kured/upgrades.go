package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Show Kured upgradable versions",
	Long:  h.Description(`Show Kured upgradable versions`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Show Kured upgradable versions")

		h.HelmSearchRepo("kured/kured")
	},
}

func init() {
	cmd.KuredCmd.AddCommand(upgradesCmd)
}

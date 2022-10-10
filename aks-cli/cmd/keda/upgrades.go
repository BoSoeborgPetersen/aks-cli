package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Show Keda upgradable versions",
	Long:  h.Description(`Show Keda upgradable versions`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		
		h.WriteInfo("Show Keda upgradable versions")
		
		h.HelmQuery("search repo kedacore/keda")
	},
}

func init() {
	cmd.KedaCmd.AddCommand(upgradesCmd)
}

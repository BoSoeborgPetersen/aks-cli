package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradesCmd = &c.Command{
	Use:   "upgrades",
	Short: "Show Vertical Pod Autoscaler upgradable versions",
	Long:  h.Description(`Show Vertical Pod Autoscaler upgradable versions`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Show Vertical Pod Autoscaler upgradable versions")

		h.WriteInfo(h.HelmQuery("search repo cowboysysop/vertical-pod-autoscaler"))
	},
}

func init() {
	cmd.VpaCmd.AddCommand(upgradesCmd)
}

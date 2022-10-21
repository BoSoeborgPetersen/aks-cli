package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradeCmd = &c.Command{
	Use:   "upgrade",
	Short: "Upgrade Vertical Pod Autoscaler",
	Long:  h.Description(`Upgrade Vertical Pod Autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		InstallFunc(h.BoolFlag("skip-namespace"), h.BoolFlag("upgrade"))
	},
}

func init() {
	cmd.VpaCmd.AddCommand(upgradeCmd)
}

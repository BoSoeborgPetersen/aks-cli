package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradeCmd = &c.Command{
	Use:   "upgrade",
	Short: "Upgrade Keda",
	Long:  h.Description(`Upgrade Keda`),
	Run: func(cmd *c.Command, args []string) {
		installCmd.Run(cmd, []string{"--skipNamespace --upgrade"})
	},
}

func init() {
	cmd.KedaCmd.AddCommand(upgradeCmd)
}

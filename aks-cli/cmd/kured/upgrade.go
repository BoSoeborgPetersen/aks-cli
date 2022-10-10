package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var upgradeCmd = &c.Command{
	Use:   "upgrade",
	Short: "Upgrade Kured",
	Long:  h.Description(`Upgrade Kured`),
	Run: func(cmd *c.Command, args []string) {
		installCmd.Run(cmd, []string{"--skip-namespace --upgrade"})
	},
}

func init() {
	cmd.KuredCmd.AddCommand(upgradeCmd)
}

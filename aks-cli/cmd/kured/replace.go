package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Uninstall & install Kured (KUbernetes REboot Daemon)",
	Long:  h.Description(`Uninstall & install Kured (KUbernetes REboot Daemon)`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Replacing Kured (KUbernetes REboot Daemon)")
		
		if h.AreYouSure() {
			uninstallCmd.Run(cmd, []string{"-y --skip-namespace"})
			installCmd.Run(cmd, []string{"--skip-namespace"})
		}
	},
}

func init() {
	cmd.KuredCmd.AddCommand(replaceCmd)
}

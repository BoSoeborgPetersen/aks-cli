package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Uninstall & install Vertical Pod Autoscaler (Helm chart)",
	Long:  h.Description(`Uninstall & install Vertical Pod Autoscaler (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Replacing Vertical Pod Autoscaler")

		if h.AreYouSure() {
			uninstallCmd.Run(cmd, []string{"-y --skipNamespace"})
			installCmd.Run(cmd, []string{"--skipNamespace"})
		}
	},
}

func init() {
	cmd.VpaCmd.AddCommand(replaceCmd)
}

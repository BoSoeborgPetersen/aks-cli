package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Uninstall & install Keda (Kubernetes Event-driven Autoscaling)",
	Long:  h.Description(`Uninstall & install Keda (Kubernetes Event-driven Autoscaling)`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Replacing Keda (Kubernetes Event-driven Autoscaling)")
		
		if h.AreYouSure() {
			uninstallCmd.Run(cmd, []string{"-y --skip-namespace"})
			installCmd.Run(cmd, []string{"--skip-namespace"})
		}
	},
}

func init() {
	cmd.KedaCmd.AddCommand(replaceCmd)
}

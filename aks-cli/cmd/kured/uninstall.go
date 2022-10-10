package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall Kured (KUbernetes REboot Daemon)",
	Long:  h.Description(`Uninstall Kured (KUbernetes REboot Daemon)`),
	Run: func(cmd *c.Command, args []string) {
		yes := h.BoolFlag(cmd, "yes")
		skipNamespace := h.BoolFlag(cmd, "skip-namespace")

		h.CheckCurrentCluster()
		deployment := h.KuredDeploymentName()

		h.WriteInfo("Uninstalling Kured (KUbernetes REboot Daemon)")

		if yes || h.AreYouSure() {
			h.HelmCommandF(h.Format("uninstall %s", deployment), deployment)

			if !skipNamespace {
				h.KubectlCommand(h.Format("delete namespace %s", deployment))
			}
		}
	},
}

func init() {
	uninstallCmd.Flags().BoolP("yes", "y", false, "Skip verification")
	uninstallCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace deletion")
	cmd.KuredCmd.AddCommand(uninstallCmd)
}
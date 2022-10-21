package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall Vertical Pod Autoscaler (Helm chart)",
	Long:  h.Description(`Uninstall Vertical Pod Autoscaler (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		skipNamespace := h.BoolFlag("skip-namespace")

		h.CheckCurrentCluster()
		deployment := h.GetConfigString(h.VpaDeploymentName)

		h.WriteInfo("Uninstalling Vertical Pod Autoscaler")

		if h.AreYouSure() {
			h.HelmCommandP("uninstall", h.HelmFlags{Name: deployment, Namespace: deployment})

			if !skipNamespace {
				h.KubectlCommand(h.Format("delete namespace %s", deployment))
			}
		}
	},
}

func init() {
	uninstallCmd.Flags().BoolP("yes", "y", false, "Skip verification")
	uninstallCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace deletion")
	cmd.VpaCmd.AddCommand(uninstallCmd)
}

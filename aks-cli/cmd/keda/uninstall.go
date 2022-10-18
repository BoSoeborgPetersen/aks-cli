package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall Keda (Kubernetes Event-driven Autoscaling)",
	Long:  h.Description(`Uninstall Keda (Kubernetes Event-driven Autoscaling)`),
	Run: func(cmd *c.Command, args []string) {
		yes := h.BoolFlag("yes")
		skipNamespace := h.BoolFlag("skip-namespace")

		h.CheckCurrentCluster()
		deployment := h.KedaDeploymentName()

		h.WriteInfo("Uninstalling Keda (Kubernetes Event-driven Autoscaling)")

		if yes || h.AreYouSure() {
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

	cmd.KedaCmd.AddCommand(uninstallCmd)
}

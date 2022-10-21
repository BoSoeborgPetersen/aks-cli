package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall Nginx (Helm chart)",
	Long:  h.Description(`Uninstall Nginx (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		purge := h.BoolFlag("purge")

		namespace := "ingress"
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag()

		h.WriteInfo("Uninstalling Nginx")

		if h.AreYouSure() {
			h.HelmCommandP("uninstall", h.HelmFlags{Name: deployment, Namespace: namespace})

			if purge {
				h.WriteInfo("Remove Nginx namespace")

				h.KubectlCommand(h.Format("delete ns %s", namespace))
			}
		}
	},
}

func init() {
	uninstallCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	uninstallCmd.Flags().Bool("purge", false, "Flag to delete Kubernetes namespace")
	uninstallCmd.Flags().BoolP("yes", "y", false, "Skip verification")
	cmd.NginxCmd.AddCommand(uninstallCmd)
}

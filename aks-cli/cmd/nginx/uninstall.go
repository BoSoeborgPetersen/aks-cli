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
		purge := h.BoolFlag(cmd, "purge")
		yes := h.BoolFlag(cmd, "yes")

		namespace := "ingress"
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag(cmd)

		h.WriteInfo("Uninstalling Nginx")

		if yes || h.AreYouSure() {
			h.HelmCommandF(h.Format("uninstall %s", deployment), namespace)

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

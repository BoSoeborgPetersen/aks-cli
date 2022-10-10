package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall & possibly remove all Kubernetes Certificate Manager resources (Issuer, Cert, Secret, Ingress, Order, Challenge)",
	Long:  h.Description(`Uninstall & possibly remove all Kubernetes Certificate Manager resources (Issuer, Cert, Secret, Ingress, Order, Challenge)`),
	Run: func(cmd *c.Command, args []string) {
		purge := h.BoolFlag(cmd, "purge")
		yes := h.BoolFlag(cmd, "yes")

		h.CheckCurrentCluster()
		deployment := h.CertManagerDeploymentName()
		latestVersion := h.HelmLatestChartVersion("jetstack/cert-manager")
		version := h.VersionFlag(cmd, latestVersion)

		h.WriteInfo("Uninstalling Cert-Manager")
		if purge {
			h.WriteInfo("Purging Cert-Manager namespace, and Custom Resource Definitions, which will remove resources (certificaterequests, certificates, challenges, clusterissuers, healthstates, issuers, orders)")
		}

		if yes || h.AreYouSure() {
			h.HelmCommandF(h.Format("uninstall %s", deployment), "cert-manager")

			if purge {
				h.KubectlCommand(h.Format("delete ns %s", deployment))
				h.KubectlCommand(h.Format("delete -f https://github.com/jetstack/cert-manager/releases/download/v%s/cert-manager.crds.yaml", version))
			}
		}
	},
}

func init() {
	uninstallCmd.Flags().String("version", "", "Helm Chart version")
	uninstallCmd.Flags().BoolP("purge", "p", false, "Also remove Kubernetes namespace and Cert-Manager Custom Resource Definitions (CRDs)")
	uninstallCmd.Flags().BoolP("yes", "y", false, "Skip verification")
	cmd.CertManagerCmd.AddCommand(uninstallCmd)
}

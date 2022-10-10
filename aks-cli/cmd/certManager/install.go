package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Certificate Manager (Helm chart)",
	Long:  h.Description(`Install Certificate Manager (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		skipNamespace := h.BoolFlag(cmd, "skip-namespace")
		upgrade := h.BoolFlag(cmd, "upgrade")

		h.CheckCurrentCluster()
		deployment := h.CertManagerDeploymentName()

		latestVersion := h.HelmLatestChartVersion("jetstack/cert-manager")
		version := h.VersionFlag(cmd, latestVersion)

		operationName := h.ConditionalOperatorOr(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Certificate Manager", operationName))

		if !skipNamespace {
			h.KubectlCommand(h.Format("create ns %s", deployment))
		}
		h.KubectlCommand(h.Format("apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v%s/cert-manager.crds.yaml", version))
		operation := h.ConditionalOperatorOr(upgrade, "upgrade", "install")
		h.HelmCommandF(h.Format("%s %s jetstack/cert-manager --version v%s -f %s/data/cert-manager/cert-manager-config.yaml", operation, deployment, version, h.ExeLocation()), deployment)
	},
}

func init() {
	installCmd.Flags().String("version", "", "Helm Chart version")
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().Bool("upgrade", false, "")
	cmd.CertManagerCmd.AddCommand(installCmd)
}

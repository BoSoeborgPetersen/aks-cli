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
		skipNamespace := h.BoolFlag("skip-namespace")
		upgrade := h.BoolFlag("upgrade")

		h.CheckCurrentCluster()
		deployment := h.CertManagerDeploymentName()
		latestVersion := h.HelmLatestChartVersion("jetstack/cert-manager")
		version := h.VersionFlag(latestVersion)

		// TODO: Try to create conditional operator as operator ("??"), like "+"
		h.WriteInfo(h.Format("%s Certificate Manager", h.IfElse(upgrade, "Upgrading", "Installing")))

		if !skipNamespace {
			h.KubectlCommand(h.Format("create ns %s", deployment))
		}
		// TODO: Put URL config file, try to use Viper for it.
		h.KubectlCommand(h.Format("apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v%s/cert-manager.crds.yaml", version))
		h.HelmCommandP(h.IfElse(upgrade, "upgrade", "install"), h.HelmFlags{Name: deployment, Repo: "jetstack/cert-manager", Namespace: deployment, Version: version, File: "/data/cert-manager/cert-manager-config.yaml"})
	},
}

func init() {
	installCmd.Flags().String("version", "", "Helm Chart version")
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().Bool("upgrade", false, "")
	cmd.CertManagerCmd.AddCommand(installCmd)
}

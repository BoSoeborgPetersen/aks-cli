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

		InstallFunc(skipNamespace, false)
	},
}

func InstallFunc(skipNamespace bool, upgrade bool) {
	h.CheckCurrentCluster()

	h.WriteInfo(h.Format("%s Certificate Manager", h.IfElse(upgrade, "Upgrading", "Installing")))

	deployment := h.GetConfigString(h.CertManagerDeploymentName)
	// TODO: Pass this function to VersionFlag and only execute if version flag is not set
	latestVersion := h.HelmLatestChartVersion("jetstack/cert-manager")
	version := h.VersionFlag(latestVersion)

	if !skipNamespace {
		h.KubectlCommand(h.Format("create ns %s", deployment))
	}
	h.Write(h.KubectlCommand(h.Format("apply --validate=false -f %s", h.GetConfigStringF(h.CertManagerUrl, version))))
	h.Write(h.HelmCommandP(h.IfElse(upgrade, "upgrade", "install"), h.HelmFlags{Name: deployment, Repo: "jetstack/cert-manager", Namespace: deployment, Version: version, File: "/data/cert-manager/cert-manager-config.yaml"}))
}

func init() {
	installCmd.Flags().String("version", "", "Helm Chart version")
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	cmd.CertManagerCmd.AddCommand(installCmd)
}

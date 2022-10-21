package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check cert-manager",
	Long:  h.Description(`Check Certificate Manager`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		deployment := h.GetConfigString(h.CertManagerDeploymentName)
		latestVersion := h.HelmLatestChartVersion("jetstack/cert-manager")
		version := h.VersionFlag(latestVersion)

		h.WriteInfo("Checking Cert-Manager")

		h.WriteInfo("Checking namespace")
		h.KubectlCheck("namespace", deployment)
		h.WriteInfo("Namespace exists")

		h.WriteInfo("Checking Custom Resource Definitions")
		h.KubectlCheckYaml(h.GetConfigStringF(h.CertManagerUrl, version))
		h.WriteInfo("Custom Resource Definitions exists")

		h.WriteInfo("Checking Helm Chart")
		h.HelmCheck(deployment, deployment)
		h.WriteInfo("Helm Chart exists")

		h.WriteInfo("Cert-Manager exists")
	},
}

func init() {
	checkCmd.Flags().String("version", "", "Helm Chart version")
	cmd.CertManagerCmd.AddCommand(checkCmd)
}

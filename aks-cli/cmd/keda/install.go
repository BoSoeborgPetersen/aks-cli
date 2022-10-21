package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Keda (Kubernetes Event-driven Autoscaling) (Helm chart)",
	Long:  h.Description(`Install Keda (Kubernetes Event-driven Autoscaling) (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		skipNamespace := h.BoolFlag("skip-namespace")
		upgrade := h.BoolFlag("upgrade")

		h.CheckCurrentCluster()
		deployment := h.GetConfigString(h.KedaDeploymentName)

		operationName := h.IfElse(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Keda (Kubernetes Event-driven Autoscaling)", operationName))

		if !skipNamespace {
			h.KubectlCommand(h.Format("create ns %s", deployment))
		}
		h.HelmCommandP(h.IfElse(upgrade, "upgrade", "install"), h.HelmFlags{Name: deployment, Repo: "kedacore/keda", Namespace: deployment, SetArgs: []string{"nodeSelector.\"kubernetes\\.io/os\"=linux"}})
	},
}

func init() {
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().Bool("upgrade", false, "Skip verification")

	cmd.KedaCmd.AddCommand(installCmd)
}

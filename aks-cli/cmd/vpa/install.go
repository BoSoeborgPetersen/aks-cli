package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Install Vertical Pod Autoscaler (Helm chart)",
	Long:  h.Description(`Install Vertical Pod Autoscaler (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		skipNamespace := h.BoolFlag("skip-namespace")
		upgrade := h.BoolFlag("upgrade")

		h.CheckCurrentCluster()

		operationName := h.IfElse(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Vertical Pod Autoscaler", operationName))

		InstallFunc(skipNamespace, upgrade)
	},
}

func InstallFunc(skipNamespace bool, upgrade bool) {
	deployment := h.GetConfigString(h.VpaDeploymentName)

	if !skipNamespace {
		h.KubectlCommand(h.Format("create ns %s", deployment))
	}
	operation := h.IfElse(upgrade, "upgrade", "install")
	h.HelmCommandP(operation, h.HelmFlags{Name: deployment, Repo: "cowboysysop/vertical-pod-autoscaler", Namespace: deployment, SetArgs: []string{`nodeSelector."kubernetes\.io/os"=linux`}})
}

func init() {
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().BoolP("upgrade", "u", false, "")
	cmd.VpaCmd.AddCommand(installCmd)
}

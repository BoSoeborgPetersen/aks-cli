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
		skipNamespace := h.BoolFlag(cmd, "skip-namespace")
		upgrade := h.BoolFlag(cmd, "upgrade")

		h.CheckCurrentCluster()
		deployment := h.VpaDeploymentName()

		operationName := h.ConditionalOperatorOr(upgrade, "Upgrading", "Installing")
		h.WriteInfo(h.Format("%s Vertical Pod Autoscaler", operationName))

		if !skipNamespace {
			h.KubectlCommand(h.Format("create ns %s", deployment))
		}
		operation := h.ConditionalOperatorOr(upgrade, "upgrade", "install")
		h.HelmCommandF(h.Format("%s %s cowboysysop/vertical-pod-autoscaler --set nodeSelector.\"kubernetes\\.io/os\"=linux", operation, deployment), deployment)
	},
}

func init() {
	installCmd.Flags().BoolP("skip-namespace", "s", false, "Skip Namespace creation")
	installCmd.Flags().BoolP("upgrade", "u", false, "")
	cmd.VpaCmd.AddCommand(installCmd)
}

package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Vertical Pod Autoscaler",
	Long:  h.Description(`Check Vertical Pod Autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		deployment := h.VpaDeploymentName()

		h.WriteInfo("Checking Vertical Pod Autoscaler")

		h.WriteInfo("Checking namespace")
		h.KubectlCheck("namespace", deployment)
		h.WriteInfo("Namespace exists")

		h.WriteInfo("Checking Helm Chart")
		h.HelmCheck(deployment, deployment)
		h.WriteInfo("Helm Chart exists")

		h.WriteInfo("Vertical Pod Autoscaler exists")
	},
}

func init() {
	cmd.VpaCmd.AddCommand(checkCmd)
}

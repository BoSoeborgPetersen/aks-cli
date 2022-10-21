package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Keda (Kubernetes Event-driven Autoscaling)",
	Long:  h.Description(`Check Keda (Kubernetes Event-driven Autoscaling)`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		deployment := h.GetConfigString(h.KedaDeploymentName)
		
		h.WriteInfo("Checking Keda (Kubernetes Event-driven Autoscaling)")
		
		h.WriteInfo("Checking namespace")
		h.KubectlCheck("namespace", deployment)
		h.WriteInfo("Namespace exists")
		
		h.WriteInfo("Checking Helm Chart")
		h.HelmCheck(deployment, deployment)
		h.WriteInfo("Helm Chart exists")
		
		h.WriteInfo("Keda (Kubernetes Event-driven Autoscaling) exists")
	},
}

func init() {
	cmd.KedaCmd.AddCommand(checkCmd)
}

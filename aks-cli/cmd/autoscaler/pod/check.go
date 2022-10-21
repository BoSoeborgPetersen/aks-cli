package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check pod autoscaler",
	Long:  h.Description(`Check pod autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck()
		deployment := h.DeploymentFlagCheck(namespace)

		h.WriteInfoF(h.Format("Checking pod autoscaler for deployment '%s'", deployment), h.WriteFlags{Namespace: namespace})
		h.KubectlCheckPodAutoscaler(deployment, namespace)
		h.WriteInfoF(h.Format("Pod autoscaler exists for deployment '%s'", deployment), h.WriteFlags{Namespace: namespace})
	},
}

func init() {
	checkCmd.Flags().String("deployment", "", h.GetConfigString(h.KubernetesDeploymentDescription))
	checkCmd.MarkFlagRequired("deployment")
	checkCmd.Flags().String("namespace", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	autoscaler.PodCmd.AddCommand(checkCmd)
}

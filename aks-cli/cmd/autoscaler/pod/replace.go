package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Replace pod autoscaler",
	Long:  h.Description(`Replace pod autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Deployment is not optional, either show menu (maybe), or change to required arg
		min := h.IntFlagRange("min", 1, 1000)
		max := h.IntFlagRange("max", 1, 1000)
		limit := h.IntFlagRange("limit", 40, 80)

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck()
		deployment := h.DeploymentFlagCheck(namespace)

		h.WriteInfoF(h.Format("Replace pod autoscaler for deployment '%s'", deployment), h.WriteFlags{Namespace: namespace})

		RemoveFunc(deployment, namespace)
		AddFunc(deployment, min, max, limit, namespace)
		// removeCmd.Run(cmd, []string{})
		// addCmd.Run(cmd, []string{})
	},
}

func init() {
	replaceCmd.Flags().String("deployment", "", h.KubernetesDeploymentDescription())
	replaceCmd.Flags().Int("min", 3, h.KubernetesMinPodCountDescription())
	replaceCmd.Flags().Int("max", 6, h.KubernetesMaxPodCountDescription())
	replaceCmd.Flags().Int("limit", 60, h.KubernetesCpuScalingLimitDescription())
	replaceCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())
	autoscaler.PodCmd.AddCommand(replaceCmd)
}

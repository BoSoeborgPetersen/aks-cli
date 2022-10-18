package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var addCmd = &c.Command{
	Use:   "add",
	Short: "Add pod autoscaler",
	Long:  h.Description(`Add pod autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Deployment is not optional, either show menu (maybe), or change to required arg
		min := h.IntFlagRange("min", 1, 1000)
		max := h.IntFlagRange("max", 1, 1000)
		limit := h.IntFlagRange("limit", 40, 80)

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck()
		deployment := h.DeploymentFlagCheck(namespace)

		h.WriteInfoF(h.Format("Add pod autoscaler (min: %d, max: %d, cpu limit: %d) to deployment '%s'", min, max, limit, deployment), h.WriteFlags{Namespace: namespace})

		// TODO: Test
		AddFunc(deployment, min, max, limit, namespace)
	},
}

func AddFunc(deployment string, min int, max int, limit int, namespace string) {
	h.Write(h.KubectlCommandF(h.Format("autoscale deploy %s --min=%d --max=%d --cpu-percent=%d", deployment, min, max, limit), h.KubectlFlags{Namespace: namespace}))
}

func init() {
	addCmd.Flags().String("deployment", "", h.KubernetesDeploymentDescription())
	addCmd.Flags().Int("min", 3, h.KubernetesMinPodCountDescription())
	addCmd.Flags().Int("max", 6, h.KubernetesMaxPodCountDescription())
	addCmd.Flags().Int("limit", 60, h.KubernetesCpuScalingLimitDescription())
	addCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())
	autoscaler.PodCmd.AddCommand(addCmd)
}

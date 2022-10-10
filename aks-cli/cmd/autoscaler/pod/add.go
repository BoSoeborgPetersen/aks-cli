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
		min := h.IntFlagRange(cmd, "min", 1, 1000)
		max := h.IntFlagRange(cmd, "max", 1, 1000)
		limit := h.IntFlagRange(cmd, "limit", 40, 80)

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck(cmd)
		deployment := h.DeploymentFlag(cmd, namespace)

		h.WriteInfoF(h.Format("Add pod autoscaler (min: %d, max: %d, cpu limit: %d) to deployment '%s'", min, max, limit, deployment), h.WriteFlags{Namespace: namespace})

		h.KubectlCommandF(h.Format("autoscale deploy %s --min=%d --max=%d --cpu-percent=%d", deployment, min, max, limit), h.KubectlFlags{Namespace: namespace})
	},
}

func init() {
	addCmd.Flags().String("deployment", "", h.KubernetesDeploymentDescription())
	addCmd.Flags().Int("min", 3, h.KubernetesMinPodCountDescription())
	addCmd.Flags().Int("max", 6, h.KubernetesMaxPodCountDescription())
	addCmd.Flags().Int("limit", 60, h.KubernetesCpuScalingLimitDescription())
	addCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())
	autoscaler.PodCmd.AddCommand(addCmd)
}

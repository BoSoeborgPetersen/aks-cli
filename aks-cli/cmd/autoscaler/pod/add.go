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
	Run: h.RunFunctionConvert(AddFunc),
}

func AddFunc() {
	min := h.IntFlagRange("min", 1, 1000)
	max := h.IntFlagRange("max", 1, 1000)
	limit := h.IntFlagRange("limit", 40, 80)

	h.CheckCurrentCluster()
	namespace := h.NamespaceFlagCheck()
	deployment := h.DeploymentFlagCheck(namespace)

	h.WriteInfoF(h.Format("Add pod autoscaler (min: %d, max: %d, cpu limit: %d) to deployment '%s'", min, max, limit, deployment), h.WriteFlags{Namespace: namespace})

	h.Write(h.KubectlCommandF(h.Format("autoscale deploy %s --min=%d --max=%d --cpu-percent=%d", deployment, min, max, limit), h.KubectlFlags{Namespace: namespace}))
}

func init() {
	addCmd.Flags().StringP("deployment", "d", "", h.GetConfigString(h.KubernetesDeploymentDescription))
	addCmd.MarkFlagRequired("deployment")
	addCmd.Flags().Int("min", 3, h.GetConfigString(h.KubernetesMinPodCountDescription))
	addCmd.Flags().Int("max", 6, h.GetConfigString(h.KubernetesMaxPodCountDescription))
	addCmd.Flags().Int("limit", 60, h.GetConfigString(h.KubernetesCpuScalingLimitDescription))
	addCmd.Flags().StringP("namespace", "n", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	autoscaler.PodCmd.AddCommand(addCmd)
}

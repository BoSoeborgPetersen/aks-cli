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
		h.WriteInfo("Replace pod autoscaler")

		RemoveFunc()
		AddFunc()
	},
}

func init() {
	replaceCmd.Flags().String("deployment", "", h.GetConfigString(h.KubernetesDeploymentDescription))
	replaceCmd.MarkFlagRequired("deployment")
	replaceCmd.Flags().Int("min", 3, h.GetConfigString(h.KubernetesMinPodCountDescription))
	replaceCmd.Flags().Int("max", 6, h.GetConfigString(h.KubernetesMaxPodCountDescription))
	replaceCmd.Flags().Int("limit", 60, h.GetConfigString(h.KubernetesCpuScalingLimitDescription))
	replaceCmd.Flags().String("namespace", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	autoscaler.PodCmd.AddCommand(replaceCmd)
}

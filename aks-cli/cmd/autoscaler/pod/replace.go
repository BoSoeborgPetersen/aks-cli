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
		deployment := h.StringFlag(cmd, "deployment")

		h.WriteInfo(h.Format("Replace pod autoscaler for deployment '%s'", deployment))

        removeCmd.Run(cmd, []string{})
        addCmd.Run(cmd, []string{})
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

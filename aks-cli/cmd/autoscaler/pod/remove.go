package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var removeCmd = &c.Command{
	Use:   "remove",
	Short: "Remove pod autoscaler",
	Long:  h.Description(`Remove pod autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck(cmd)
		deployment := h.DeploymentFlag(cmd, namespace)

		h.WriteInfoF(h.Format("Remove pod autoscaler for deployment '%s'", deployment), h.WriteFlags{ Namespace: namespace })

		h.KubectlCommandF(h.Format("delete hpa %s", deployment), h.KubectlFlags{ Namespace: namespace })
	},
}

func init() {
	removeCmd.Flags().String("deployment", "", h.KubernetesDeploymentDescription())
	removeCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())
	autoscaler.PodCmd.AddCommand(removeCmd)
}

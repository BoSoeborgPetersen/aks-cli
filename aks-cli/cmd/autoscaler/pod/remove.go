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
	Run:   h.RunFunctionConvert(RemoveFunc),
}

func RemoveFunc() {
	h.CheckCurrentCluster()
	namespace := h.NamespaceFlagCheck()
	deployment := h.DeploymentFlagCheck(namespace)

	h.WriteInfoF(h.Format("Remove pod autoscaler for deployment '%s'", deployment), h.WriteFlags{Namespace: namespace})

	h.KubectlCommandF(h.Format("delete hpa %s", deployment), h.KubectlFlags{Namespace: namespace})
}

func init() {
	removeCmd.Flags().String("deployment", "", h.GetConfigString(h.KubernetesDeploymentDescription))
	removeCmd.MarkFlagRequired("deployment")
	removeCmd.Flags().String("namespace", "", h.GetConfigString(h.KubernetesNamespaceDescription))
	autoscaler.PodCmd.AddCommand(removeCmd)
}

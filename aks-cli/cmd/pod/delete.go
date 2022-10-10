package pod

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var deleteCmd = &c.Command{
	Use:   "delete",
	Short: "Delete deployment pods",
	Long:  h.Description(`Delete deployment pods`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck(cmd)
		deployment := h.DeploymentFlag(cmd, namespace)

		pods := h.KubectlGetPods(deployment, namespace)

		h.WriteInfo(h.Format("Safely deleting pods for deployment '%s' in namespace '%s':\n%s", deployment, namespace, h.JoinF(pods, "\n")))

		if h.AreYouSure() {
			for _, pod := range pods {
				h.KubectlCommandF(h.Format("delete pod %s", pod), h.KubectlFlags{Namespace: namespace})
				h.KubectlCommandF(h.Format("rollout status deploy/%s", deployment), h.KubectlFlags{Namespace: namespace})
			}
		}
	},
}

func init() {
	deleteCmd.Flags().StringP("deployment", "d", "", "Kubernetes deployment")
	deleteCmd.Flags().StringP("namespace", "n", "", h.KubernetesNamespaceDescription())
	cmd.PodCmd.AddCommand(deleteCmd)
}

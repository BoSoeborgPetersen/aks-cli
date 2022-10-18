package scale

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var podsCmd = &c.Command{
	Use:   "pods <count>",
	Short: "Scale Kubernetes deployment (Pod scaling)",
	Long:  h.Description(`Scale Kubernetes deployment (Pod scaling)`),
	Args:  h.RequiredArg("number (<count>) of pods"),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		count := h.IntArgRange(args, 0, "count", 0, 100)
		namespace := h.NamespaceFlagCheck()
		deployment := h.DeploymentFlagCheck(namespace)

		h.WriteInfo(h.Format("Scaling number of pods to '%d', for deployment '%s' in namespace '%s'", count, deployment, namespace))

		h.KubectlCommandF(h.Format("scale --replicas %d deploy/%s", count, deployment), h.KubectlFlags{Namespace: namespace})
	},
}

func init() {
	podsCmd.Flags().String("deployment", "", "Kubenetes deployment")
	podsCmd.Flags().String("namespace", "", h.KubernetesNamespaceDescription())

	cmd.ScaleCmd.AddCommand(podsCmd)
}

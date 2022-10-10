package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs",
	Short: "Get Nginx Deployment logs",
	Long:  h.Description(`Get Nginx Deployment logs`),
	Run: func(cmd *c.Command, args []string) {
		index := h.IntFlag(cmd, "index")

		namespace := "ingress"
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag(cmd)
		// TODO: Could be part of NginxDeploymentNamePrefixFlagCheck func (but shoudl probably be called NginxDaemonSetNamePrefixFlagCheck)
		h.KubectlCheckDaemonSet(deployment, namespace)

		if index != -1 {
			h.WriteInfo(h.Format("Show Nginx logs from pod (index: %d) in deployment '%s'", index, deployment))

			pod := h.KubectlGetPod(deployment, namespace, index)
			h.KubectlCommand(h.Format("logs -n %s %s", namespace, pod))
		} else {
			h.WriteInfo("Show Nginx logs with Stern")

			h.SternCommand(deployment, namespace)
		}
	},
}

func init() {
	logsCmd.Flags().Int("index", -1, "Index of the pod to show logs from")
	logsCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	cmd.NginxCmd.AddCommand(logsCmd)
}

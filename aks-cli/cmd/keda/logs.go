package keda

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs",
	Short: "Get Keda (Kubernetes Event-driven Autoscaling) logs",
	Long:  h.Description(`Get Keda (Kubernetes Event-driven Autoscaling) logs`),
	Run: func(cmd *c.Command, args []string) {
		index := h.IntFlag(cmd, "index")

		h.CheckCurrentCluster()
		deployment := h.KedaDeploymentName()

		if index != -1 {
			h.WriteInfo(h.Format("Show Keda (Kubernetes Event-driven Autoscaling) logs from pod (index: %d)", index))

			pod := h.KubectlGetPod(deployment, deployment, index)
			h.KubectlCommand(h.Format("logs %s -n %s", pod, deployment))
		} else {
			h.WriteInfo("Show Keda (Kubernetes Event-driven Autoscaling) logs with Stern")

			h.SternCommand(deployment, deployment)
		}
	},
}

func init() {
	logsCmd.Flags().IntP("index", "i", -1, "Index of the pod to show logs from")

	cmd.KedaCmd.AddCommand(logsCmd)
}

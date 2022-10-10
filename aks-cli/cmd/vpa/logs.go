package vpa

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs",
	Short: "Get Vertical Pod Autoscaler logs",
	Long:  h.Description(`Get Vertical Pod Autoscaler logs`),
	Run: func(cmd *c.Command, args []string) {
		index := h.IntFlag(cmd, "index")

		h.CheckCurrentCluster()
		deployment := h.VpaDeploymentName()

		if index != -1 {
			h.WriteInfo(h.Format("Show Vertical Pod Autoscaler logs from pod (index: %d)", index))

			pod := h.KubectlGetPod(deployment, deployment, index)
			h.KubectlCommand(h.Format("logs %s -n %s", pod, deployment))
		} else {
			h.WriteInfo("Show Vertical Pod Autoscaler logs with Stern")

			h.SternCommand(deployment, deployment)
		}
	},
}

func init() {
	logsCmd.Flags().IntP("index", "i", -1, "Index of the pod to show logs from")
	cmd.VpaCmd.AddCommand(logsCmd)
}

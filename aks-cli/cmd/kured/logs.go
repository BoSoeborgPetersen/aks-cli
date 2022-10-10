package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs",
	Short: "Get Kured (KUbernetes REboot Daemon) logs",
	Long:  h.Description(`Get Kured (KUbernetes REboot Daemon) logs`),
	Run: func(cmd *c.Command, args []string) {
		index := h.IntFlag(cmd, "index")
		
		h.CheckCurrentCluster()
		deployment := h.KuredDeploymentName()
		
		if index != -1 {
			h.WriteInfo(h.Format("Show Kured (KUbernetes REboot Daemon) logs from pod (index: %d)", index))
			
			pod := h.KubectlGetPod(deployment, deployment, index)
			h.KubectlCommand(h.Format("logs %s -n %s", pod, deployment))
		} else {
			h.WriteInfo("Show Kured (KUbernetes REboot Daemon) logs with Stern")
		
			h.SternCommand(deployment, deployment)
		}
	},
}

func init() {
	logsCmd.Flags().IntP("index", "i", -1, "Index of the pod to show logs from")
	cmd.KuredCmd.AddCommand(logsCmd)
}

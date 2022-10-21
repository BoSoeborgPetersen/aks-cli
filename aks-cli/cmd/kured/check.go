package kured

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Kured (KUbernetes REboot Daemon)",
	Long:  h.Description(`Check Kured (KUbernetes REboot Daemon)`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		deployment := h.GetConfigString(h.KuredDeploymentName)

		h.WriteInfo("Checking Kured (KUbernetes REboot Daemon)")

		h.WriteInfo("Checking namespace")
		h.KubectlCheck("namespace", deployment)
		h.WriteInfo("Namespace exists")

		h.WriteInfo("Checking Helm Chart")
		h.HelmCheck(deployment, deployment)
		h.WriteInfo("Helm Chart exists")

		h.WriteInfo("Kured (KUbernetes REboot Daemon) exists")
	},
}

func init() {
	cmd.KuredCmd.AddCommand(checkCmd)
}

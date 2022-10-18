package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Nginx",
	Long:  h.Description(`Check Nginx`),
	Run: func(cmd *c.Command, args []string) {
		namespace := "ingress"
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag()

		h.WriteInfo("Checking Nginx")

		// LaterDo: Check Public IP.

		h.WriteInfo("Checking namespace")
		h.KubectlCheck("namespace", namespace)
		h.WriteInfo("Namespace exists")

		h.WriteInfo("Checking Nginx Chart")
		h.HelmCheck(deployment, namespace)
		h.WriteInfo("Nginx Chart exists")

		h.WriteInfo("Nginx exists")
	},
}

func init() {
	checkCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	cmd.NginxCmd.AddCommand(checkCmd)
}

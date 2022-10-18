package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var printCmd = &c.Command{
	Use:   "print",
	Short: "Prints the contents of the nginx.conf file inside the Nginx pod",
	Long:  h.Description(`Prints the contents of the nginx.conf file inside the Nginx pod`),
	Run: func(cmd *c.Command, args []string) {
		index := h.IntFlag("index")

		namespace := "ingress"
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag()
		h.KubectlCheckDaemonSet(deployment, namespace)

		h.WriteInfo("Print Nginx config file from inside the container")

		pod := h.KubectlGetPod(deployment, namespace, index)
		h.KubectlCommand(h.Format("exec -n %s %s -- cat /etc/nginx/nginx.conf", namespace, pod))
	},
}

func init() {
	printCmd.Flags().Int("index", 0, "Index of the pod to show logs from")
	printCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	cmd.NginxCmd.AddCommand(printCmd)
}

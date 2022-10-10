package nginx

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var editCmd = &c.Command{
	Use:   "edit",
	Short: "Opens the Nginx configmap for editing in notepad",
	Long:  h.Description(`Opens the Nginx configmap for editing in notepad`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		deployment := h.NginxDeploymentNamePrefixFlag(cmd)
		configMap := h.Format("%s-controller", deployment)

		h.WriteInfo("Edit Nginx configmap")

		configMapExists := h.KubectlQueryF("get configmap", h.KubectlFlags{Namespace: "ingress", JsonPath: h.Format("{$.items[?(@.metadata.name=='%s')].metadata.name}", configMap)})
		if configMapExists == "" {
			h.KubectlCommandF(h.Format("create configmap ", configMap), h.KubectlFlags{Namespace: "ingress"})
		}

		h.KubectlCommandF(h.Format("edit configmap ", configMap), h.KubectlFlags{Namespace: "ingress"})
	},
}

func init() {
	editCmd.Flags().String("prefix", "", "Kubernetes deployment name prefix")
	cmd.NginxCmd.AddCommand(editCmd)
}

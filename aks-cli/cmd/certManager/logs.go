package certManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var logsCmd = &c.Command{
	Use:   "logs",
	Short: "Get cert-manager logs",
	Long:  h.Description(`Get Certificate Manager logs`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Add regex for choosing pod, as alternative to index
		index := h.IntFlag("index")

		h.CheckCurrentCluster()
		// TODO: Put in config file with Viper
		// TODO: Put cert-manager namespace name in config file
		deployment := h.CertManagerDeploymentName()

		if index != -1 {
			h.WriteInfo(h.Format("Show Cert-Manager logs from pod (index: %d) in deployment '%s'", index, deployment))

			pod := h.KubectlGetPod(deployment, "cert-manager", index)
			h.KubectlCommandF(h.Format("logs %s", pod), h.KubectlFlags{Namespace: "cert-manager"})
		} else {
			h.WriteInfo("Show Cert-Manager logs with Stern")

			h.SternCommand(deployment, h.SternFlags{Namespace: "cert-manager"})
		}
	},
}

func init() {
	logsCmd.Flags().IntP("index", "i", -1, "Index of the pod to show logs from")

	cmd.CertManagerCmd.AddCommand(logsCmd)
}

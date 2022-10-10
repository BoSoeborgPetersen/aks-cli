package monitoring

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Uninstall Monitoring with Prometheus and Grafana (Helm chart)",
	Long:  h.Description(`Uninstall Monitoring with Prometheus and Grafana (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Uninstalling Monitoring (Prometheus & Grafana)")

		if h.AreYouSure() {
			h.HelmCommandF("uninstall grafana", "monitoring")
			h.HelmCommandF("uninstall prometheus", "monitoring")
		}
	},
}

func init() {
	cmd.MonitoringCmd.AddCommand(uninstallCmd)
}

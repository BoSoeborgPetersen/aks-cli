package monitoring

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Monitoring with Prometheus and Grafana (Helm chart)",
	Long:  h.Description(`Check Monitoring with Prometheus and Grafana (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Test
		h.CheckCurrentCluster()

		h.WriteInfo("Checking Monitoring")

		h.WriteInfo("Checking Prometheus Helm Chart")
		h.HelmCheck("prometheus", "monitoring")
		h.WriteInfo("Checking Grafana Helm Chart")
		h.HelmCheck("grafana", "monitoring")
	},
}

func init() {
	cmd.MonitoringCmd.AddCommand(checkCmd)
}

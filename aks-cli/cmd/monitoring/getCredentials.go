package monitoring

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var getCredentialsCmd = &c.Command{
	Use:   "getCredentials",
	Short: "Get credentials for Grafana (Helm chart)",
	Long:  h.Description(`Get credentials for Grafana (Helm chart)`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		
		h.KubectlQuery("get secret --namespace monitoring grafana -o jsonpath='{.data.admin-password}' | base64 -d")
	},
}

func init() {
	cmd.MonitoringCmd.AddCommand(getCredentialsCmd)
}

package insights

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Azure Operational Insights",
	Long:  h.Description(`Check Azure Operational Insights`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		resourceGroup := h.CurrentClusterResourceGroup()
		insights := h.InsightsName(resourceGroup)

		h.WriteInfo(h.Format("Checking Operational Insights '%s'", insights))

		h.WriteInfo("Checking log-analytics workspace")
		h.AzCheckInsights(resourceGroup, insights)
		h.WriteInfo("Log-analytics workspace exists")

		// LaterDo: Check that log-analytics workspace has free sku

		h.WriteInfo("Checking monitoring addon")
		h.AzCheckMonitoringAddon()
		h.WriteInfo("Monitoring addon exists")

		h.WriteInfo(h.Format("Operational Insights '%s' exists", insights))
	},
}

func init() {
	cmd.InsightsCmd.AddCommand(checkCmd)
}

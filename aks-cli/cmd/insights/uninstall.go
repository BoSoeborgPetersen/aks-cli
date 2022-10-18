package insights

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var uninstallCmd = &c.Command{
	Use:   "uninstall",
	Short: "Detach Azure Operational Insights Workspace from AKS cluster, and delete it",
	Long:  h.Description(`Detach Azure Operational Insights Workspace from AKS cluster, and delete it`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		resourceGroup := h.CurrentClusterResourceGroup()
		insights := h.InsightsName(resourceGroup)
		
		h.WriteInfo(h.Format("Uninstalling Operational Insights '%s'", insights))
		
		if h.AreYouSure() {
			h.AzAksCurrentCommand("disable-addons -a monitoring")
			h.AzCommand(h.Format("monitor log-analytics workspace delete -g %s -n %s", resourceGroup, insights))
		}
 	},
}

func init() {
	cmd.InsightsCmd.AddCommand(uninstallCmd)
}

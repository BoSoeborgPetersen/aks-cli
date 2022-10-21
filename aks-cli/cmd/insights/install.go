package insights

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var installCmd = &c.Command{
	Use:   "install",
	Short: "Create & attach Azure Operational Insights Workspace to AKS cluster",
	Long:  h.Description(`Create Azure Operational Insights Workspace and attach it to the AKS cluster`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup
		insights := h.GetConfigStringF(h.InsightsName, resourceGroup)

		h.WriteInfo(h.Format("Installing Operational Insights '%s'", insights))

		h.AzCommand(h.Format("monitor log-analytics workspace create -g %s -n %s", resourceGroup, insights))
		h.AzCommand(h.Format("monitor log-analytics workspace update -g %s -n %s --set sku.name=free --set retentionInDays=7", resourceGroup, insights))
		id := h.AzQueryP(h.Format("monitor log-analytics workspace show -g %s -n %s", resourceGroup, insights), h.AzFlags{Query: "id", Output: "tsv"})
		h.Write(h.AzAksCurrentCommand(h.Format("enable-addons -a monitoring --workspace-resource-id %s", id)))
	},
}

func init() {
	cmd.InsightsCmd.AddCommand(installCmd)
}

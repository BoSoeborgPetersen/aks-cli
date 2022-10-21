package trafficManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var redirectAllCmd = &c.Command{
	Use:   "redirect-all",
	Short: "Find all Traffic Managers pointing a source AKS cluster and point them to a target AKS cluster",
	Long:  h.Description(`Find all Traffic Managers pointing a source AKS cluster and point them to a target AKS cluster`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Rewrite
		// BUG: Problem observed when the dns name of public IP that the new endpoint points to has the dns name of the old IP that the old endpoint is pointing to. Replacing endpont instead of adding should fix it.

		// Step 1: Choose source cluster
		h.WriteInfo("Choose source AKS cluster")
		sourceCluster := h.ClusterMenu(false)

		// Step 2: Choose target cluster
		h.WriteInfo("Choose target AKS cluster")
		targetCluster := h.ClusterMenu(false)

		h.WriteInfo(h.Format("Redirect all Traffic Managers from '%s' to '%s'", sourceCluster.Name, targetCluster.Name))

		// Step 3: Find all traffic managers pointing to the Public IP resource of the source cluster.
		subscriptionId := h.GetGlobalCurrentSubscription().Id
		sourceResourceGroup := sourceCluster.ResourceGroup
		sourceNodeResourceGroup := sourceCluster.NodeResourceGroup
		sourceIpAddresses := h.Fields(h.AzQueryP("network public-ip list", h.AzFlags{Query: h.Format("[?resourceGroup=='%s' && starts_with(ipConfiguration.resourceGroup,'%s')].id", sourceResourceGroup, sourceNodeResourceGroup), Output: "tsv"}))
		// sourcePublicIp := h.PublicIpName(sourceCluster.name)
		// sourcePublicIpId := h.Format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/publicIPAddresses/%s", subscriptionId, sourceResourceGroup, sourcePublicIp)

		if h.AreYouSure() {
			for _, sourceIpAddress := range sourceIpAddresses {
				trafficManagers := make([]TrafficManager, 0)
				h.Deserialize(h.AzQueryP("network traffic-manager profile list", h.AzFlags{Query: h.Format("[?endpoints[].targetResourceId==%s]", sourceIpAddress)}), &trafficManagers)

				// Step 4: Update Traffic Managers to point to the Public IP resource of the target cluster.
				targetResourceGroup := targetCluster.ResourceGroup

				targetPublicIp := h.GetConfigStringF(h.PublicIpName, targetCluster.Name)
				targetPublicIpId := h.Format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/publicIPAddresses/%s", subscriptionId, targetResourceGroup, targetPublicIp)

				for _, trafficManager := range trafficManagers {
					h.AzCommand(h.Format("network traffic-manager endpoint create -g %s --profile-name %s -n '%s' --type azureEndpoints --target-resource-id %s", trafficManager.ResourceGroup, trafficManager.Name, targetCluster.Name, targetPublicIpId))
					for _, endpoint := range trafficManager.Endpoints {
						h.AzCommand(h.Format("network traffic-manager endpoint update -g %s --profile-name %s -n '%s' --endpoint-status Disabled", trafficManager.ResourceGroup, trafficManager.Name, endpoint.Name))
						// h.AzCommand(h.Format("network traffic-manager endpoint delete -g %s --profile-name %s -n '%s' --type %s", trafficManager.ResourceGroup, trafficManager.Name, endpoint.Name, endpoint.Type))
					}
				}
			}
		}
	},
}

type TrafficManager struct {
	ResourceGroup string
	Name          string
	Endpoints     []Endpoint
}

type Endpoint struct {
	Name string
	Type string
}

func init() {
	cmd.TrafficManagerCmd.AddCommand(redirectAllCmd)
}

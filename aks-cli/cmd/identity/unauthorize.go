package identity

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var unauthorizeCmd = &c.Command{
	Use:   "unauthorize <global subscription>",
	Short: "Unauthorize AKS cluster Managed Identity from accessing global resources (cluster Resource Group & Azure Container Registry)",
	Long:  h.Description(`Unauthorize AKS cluster Managed Identity from accessing global resources (cluster Resource Group & Azure Container Registry)`),
	Args:  h.RequiredArg("Azure <Global Subscription> for global resources (cluster Resource Group & Azure Container Registry)"),
	Run: func(cmd *c.Command, args []string) {
		// LaterDo: Check if Managed Identity is authorized.
		// LaterDo: With more than 1 registry in the global subscription, show menu to choose.
		h.CheckCurrentCluster()
		globalSubscription := h.SubscriptionArgCheck(0)
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup
		subscriptionId := h.GetGlobalCurrentSubscription().Id

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo(`Unauthorize AKS cluster Managed Identity from accessing global resources:
		 - Cluster Resource Group
		 - Azure Container Registry`)

		systemId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identity.principalId", Output: "tsv"})
		userId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identityProfile.kubeletidentity.clientId", Output: "tsv"})

		h.AzCommand(h.Format("role assignment delete --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", systemId, subscriptionId, resourceGroup))
		h.AzCommand(h.Format("role assignment delete --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", userId, globalSubscriptionId, globalResourceGroup))
	},
}

func init() {
	cmd.IdentityCmd.AddCommand(unauthorizeCmd)
}

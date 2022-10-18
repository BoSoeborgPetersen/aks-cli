package identity

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var authorizeCmd = &c.Command{
	Use:   "authorize <global subscription>",
	Short: "Authorize AKS cluster Managed Identity to access global resources",
	Long:  h.Description(`Authorize AKS cluster Managed Identity to access global resources (cluster Resource Group & Azure Container Registry)`),
	Args:  h.RequiredArg("Azure <Global Subscription> for global resources"),
	Run: func(cmd *c.Command, args []string) {
		// LaterDo: Check if Managed Identity is already authorized.
		// LaterDo: With more than 1 registry in the global subscription, show menu to choose.
		h.CheckCurrentCluster()
		globalSubscription := h.SubscriptionArgCheck(args, 0)
		resourceGroup := h.CurrentClusterResourceGroup()
		subscriptionId := h.CurrentSubscription()

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo(`Authorize AKS cluster Managed Identity to access global resources:
		 - Cluster Resource Group
		 - Azure Container Registry`)

		systemId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identity.principalId", Output: "tsv"})
		userId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identityProfile.kubeletidentity.clientId", Output: "tsv"})

		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", systemId, subscriptionId, resourceGroup))
		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", userId, globalSubscriptionId, globalResourceGroup))
	},
}

func init() {
	cmd.IdentityCmd.AddCommand(authorizeCmd)
}

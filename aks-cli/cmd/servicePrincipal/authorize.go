package servicePrincipal

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var authorizeCmd = &c.Command{
	Use:   "authorize <global subscription>",
	Short: "Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)",
	Long:  h.Description(`Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)`),
	// Args:  h.RequiredArg("Azure <Global Subscription> for global resources (cluster Resource Group & Azure Container Registry)"),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Check if Service Principal is already authorized.
		globalSubscription := args[0]

		// NOWDO: Move to function based on RequiredArg 
		if globalSubscription == "" {
			globalSubscription = h.SubscriptionMenu().Name
		}

		h.CheckCurrentCluster()
		h.CheckVariable(globalSubscription, "global subscription")
		resourceGroup := h.CurrentClusterResourceGroup()
		h.AzCheckSubscription(globalSubscription)
		subscriptionId := h.CurrentSubscription()

		registry := h.AzQueryF("acr list", h.AzQueryFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryF("account list", h.AzQueryFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryF("acr list", h.AzQueryFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo("Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)")

		id := h.AzAksCurrentQueryF("show", h.AzAksQueryFlags{Query: "servicePrincipalProfile", Output: "tsv"})

		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, subscriptionId, resourceGroup))
		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, globalSubscriptionId, globalResourceGroup))
	},
}

func init() {
	cmd.ServicePrincipalCmd.AddCommand(authorizeCmd)
}

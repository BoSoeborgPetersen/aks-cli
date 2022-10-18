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

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		// globalSubscriptionId := h.Az{Command: "account list",Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"}.Pure()
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo("Authorize AKS cluster Service Principal to access global resources (cluster Resource Group & Azure Container Registry)")

		id := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "servicePrincipalProfile", Output: "tsv"})

		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, subscriptionId, resourceGroup))
		h.AzCommand(h.Format("role assignment create --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, globalSubscriptionId, globalResourceGroup))
	},
}

func init() {
	cmd.ServicePrincipalCmd.AddCommand(authorizeCmd)
}

package servicePrincipal

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var unauthorizeCmd = &c.Command{
	Use:   "unauthorize <global subscription>",
	Short: "Unauthorize AKS cluster Service Principal from accessing global resources (cluster Resource Group & Azure Container Registry)",
	Long:  h.Description(`Unauthorize AKS cluster Service Principal from accessing global resources (cluster Resource Group & Azure Container Registry)`),
	Args:  h.RequiredArg("Azure <Global Subscription> for global resources (cluster Resource Group & Azure Container Registry)"),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Check if Service Principal is authorized.

		h.CheckCurrentCluster()
		globalSubscription := h.SubscriptionArgCheck(args, 0)
		resourceGroup := h.CurrentClusterResourceGroup()
		subscriptionId := h.CurrentSubscription()

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo("Unauthorize AKS cluster Service Principal from accessing global resources (cluster Resource Group & Azure Container Registry)")

		id := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "servicePrincipalProfile", Output: "tsv"})

		h.AzCommand(h.Format("role assignment delete --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, subscriptionId, resourceGroup))
		h.AzCommand(h.Format("role assignment delete --assignee %s --role contributor --scope /subscriptions/%s/resourceGroups/%s", id, globalSubscriptionId, globalResourceGroup))

	},
}

func init() {
	cmd.ServicePrincipalCmd.AddCommand(unauthorizeCmd)
}

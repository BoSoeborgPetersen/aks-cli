package servicePrincipal

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <global subscription>",
	Short: "Check AKS cluster Service Principal",
	Long:  h.Description(`Check AKS cluster Service Principal`),
	Args:  h.RequiredArg("Azure <Global Subscription> for global resources (cluster Resource Group & Azure Container Registry)"),
	Run: func(cmd *c.Command, args []string) {
		globalSubscription := h.StringArg(0)

		if !h.IsSet(globalSubscription) {
			globalSubscription = h.SubscriptionMenu().Name
		}

		h.CheckCurrentCluster()
		h.CheckVariable(globalSubscription, "global subscription")
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup
		h.AzCheckSubscription(globalSubscription)
		subscriptionId := h.GetGlobalCurrentSubscription().Id

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo("Checking current AKS cluster service principal")
		id := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "servicePrincipalProfile", Output: "tsv"})
		h.AzCheckRoleAssignment(id, subscriptionId, resourceGroup)
		h.AzCheckRoleAssignment(id, globalSubscriptionId, globalResourceGroup)
		h.WriteInfo("Current AKS cluster service principal exists")
	},
}

func init() {
	cmd.ServicePrincipalCmd.AddCommand(checkCmd)
}

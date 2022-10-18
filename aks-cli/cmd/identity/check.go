package identity

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <global subscription>",
	Short: "Check AKS cluster Managed Identity",
	Long:  h.Description(`Check AKS cluster Managed Identity`),
	Args:  h.RequiredArg("Azure <Global Subscription> for global resources (cluster Resource Group & Azure Container Registry)"),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		globalSubscription := h.SubscriptionArgCheck(args, 0)
		resourceGroup := h.CurrentClusterResourceGroup()
		subscriptionId := h.CurrentSubscription()

		registry := h.AzQueryP("acr list", h.AzFlags{Query: "[].name", Output: "tsv", Subscription: globalSubscription})
		h.AzCheckContainerRegistry(registry, globalSubscription)
		globalSubscriptionId := h.AzQueryP("account list", h.AzFlags{Query: h.Format("[?name=='%s'].id", globalSubscription), Output: "tsv"})
		globalResourceGroup := h.AzQueryP("acr list", h.AzFlags{Query: h.Format("[?name=='%s'].resourceGroup", registry), Output: "tsv", Subscription: globalSubscription})
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)

		h.WriteInfo("Checking Managed Identity")

		h.WriteInfo("Checking current AKS cluster managed identity (system assigned)")
		systemId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identity.principalId", Output: "tsv"})
		h.AzCheckRoleAssignment(systemId, subscriptionId, resourceGroup)
		h.WriteInfo("Current AKS cluster managed identity (system assigned) exists")

		h.WriteInfo("Checking current AKS cluster managed identity (user assigned)")
		userId := h.AzAksCurrentQueryP("show", h.AzAksFlags{Query: "identityProfile.kubeletidentity.clientId", Output: "tsv"})
		h.AzCheckRoleAssignment(userId, globalSubscriptionId, globalResourceGroup)
		h.WriteInfo("Current AKS cluster managed identity (user assigned) exists")

		h.WriteInfo("Managed Identity exists")
	},
}

func init() {
	cmd.IdentityCmd.AddCommand(checkCmd)
}

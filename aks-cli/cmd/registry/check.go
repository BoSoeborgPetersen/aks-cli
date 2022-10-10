package registry

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <resource group> <global subscription>",
	Short: "Check Azure Container Registry",
	Long:  h.Description(`Check Azure Container Registry`),
	Args: h.RequiredAll(
		h.RequiredArg("Azure <resource group>"),
		h.RequiredArgAt("Azure <global subscription> for Azure Container Registry", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		resourceGroup := args[0]
		globalSubscription := args[1]
		// TODO: Test

		globalResourceGroup := h.GlobalResourceGroupName(resourceGroup)
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)
		registry := h.RegistryName(resourceGroup)

		h.WriteInfo("Checking Registry")
		h.AzCheckContainerRegistry(registry, globalSubscription)
		h.WriteInfo("Registry exists")
	},
}

func init() {
	cmd.RegistryCmd.AddCommand(checkCmd)
}

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
		resourceGroup := h.StringArg(0)
		globalSubscription := h.StringArg(1)
		// TODO: Test

		globalResourceGroup := h.GetConfigStringF(h.GlobalResourceGroupName, h.StringMiddle(resourceGroup))
		h.AzCheckResourceGroup(globalResourceGroup, globalSubscription)
		registry := h.GetConfigStringF(h.RegistryName, h.StringMiddle(resourceGroup))

		h.WriteInfo("Checking Registry")
		h.AzCheckContainerRegistry(registry, globalSubscription)
		h.WriteInfo("Registry exists")
	},
}

func init() {
	cmd.RegistryCmd.AddCommand(checkCmd)
}

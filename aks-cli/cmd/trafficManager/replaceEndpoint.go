package trafficManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceEndpointCmd = &c.Command{
	Use:   "replace-endpoint <new>",
	Short: "Replace Traffic Manager Endpoint pointing to AKS cluster",
	Long:  h.Description(`Replace Traffic Manager Endpoint pointing to AKS cluster`),
	Args:  h.RequiredArg("<new> endpoint name"),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Rewrite
		new := args[0]
		old := h.StringFlag(cmd, "old")

		AzureServiceResourceGroup := ""
		AzureTrafficManager := ""
		AzureReservedIp := ""
		h.AzCommand(h.Format("network traffic-manager endpoint create -g %s --profile-name %s -n %s --type azureEndpoints --target-resource-id %s --endpoint-status enabled", AzureServiceResourceGroup, AzureTrafficManager, old, AzureReservedIp))
		h.AzCommand(h.Format("network traffic-manager endpoint update -g %s --profile-name %s -n %s --endpoint-status Disabled", AzureServiceResourceGroup, AzureTrafficManager, new))
	},
}

func init() {
	replaceEndpointCmd.Flags().String("old", "AKS", "old endpoint name")
	cmd.TrafficManagerCmd.AddCommand(replaceEndpointCmd)
}

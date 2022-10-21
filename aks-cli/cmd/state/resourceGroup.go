// TODO: Rename to Config and put in config file
package state

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var resourceGroupCmd = &c.Command{
	Use:   "resourceGroup",
	Short: "Change default Resource Group",
	Long:  h.Description(`Change default Resource Group`),
	Run: func(cmd *c.Command, args []string) {
		// MaybeDo: Use this default resource group in all aks functions that require a resource group.
		resourceGroup := h.StringFlag("resourceGroup")

		if h.IsSet(resourceGroup) {
			h.WriteInfo(h.Format("Setting global state to use default resource group '%s'", resourceGroup))
		} else {
			h.WriteInfo("Setting global state to not use a default resource group")
		}

		h.SetConfigString(h.GlobalDefaultResourceGroup, resourceGroup)
	},
}

func init() {
	resourceGroupCmd.Flags().StringP("resourceGroup", "r", "", "Default resource group")
	cmd.StateCmd.AddCommand(resourceGroupCmd)
}

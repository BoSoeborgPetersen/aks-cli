package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var refreshCmd = &c.Command{
	Use:   "refresh",
	Short: "Refresh node autoscaler",
	Long:  h.Description(`Refresh (disable, then enable) node autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("Refreshing (disabling, then enabling) node autoscaler")

		DisableFunc()
		EnableFunc()
	},
}

func init() {
	refreshCmd.Flags().Int("min", 2, h.GetConfigString(h.AzureVmMinNodeCountDescription))
	refreshCmd.Flags().Int("max", 4, h.GetConfigString(h.AzureVmMaxNodeCountDescription))
	autoscaler.NodeCmd.AddCommand(refreshCmd)
}

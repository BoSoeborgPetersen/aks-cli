package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var refreshCmd = &c.Command{
	Use:   "refresh",
	Short: "Refresh node autoscaler",
	Long:  h.Description(`Refresh node autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		min := h.IntFlag(cmd, "min")
		max := h.IntFlag(cmd, "max")

		h.WriteInfo("Refresh (disable, then enable) node autoscaler")

		disableCmd.Run(cmd, []string{})
		enableCmd.Run(cmd, []string{h.Format("--min %d --max %d", min, max)})
	},
}

func init() {
	refreshCmd.Flags().Int("min", 2, h.AzureVmMinNodeCountDescription())
	refreshCmd.Flags().Int("max", 4, h.AzureVmMaxNodeCountDescription())
	autoscaler.NodeCmd.AddCommand(refreshCmd)
}

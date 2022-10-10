package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var enableCmd = &c.Command{
	Use:   "enable",
	Short: "Disable node autoscaler",
	Long:  h.Description(`Disable node autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		min := h.IntFlagRange(cmd, "min", 2, 100)
		max := h.IntFlagRange(cmd, "max", 2, 100)

		h.CheckCurrentCluster()

		h.WriteInfo("Enable node autoscaler")

		h.PrintAzAksCurrentCommand(h.Format("update --enable-cluster-autoscaler --min-count %d --max-count %d", min, max))
	},
}

func init() {
	enableCmd.Flags().Int("min", 2, h.AzureVmMinNodeCountDescription())
	enableCmd.Flags().Int("max", 4, h.AzureVmMaxNodeCountDescription())
	autoscaler.NodeCmd.AddCommand(enableCmd)
}

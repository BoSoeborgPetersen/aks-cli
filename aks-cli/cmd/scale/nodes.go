package scale

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var nodesCmd = &c.Command{
	Use:   "nodes <count>",
	Short: "Scale Azure VM Scale Set (Node scaling)",
	Long:  h.Description(`Scale Azure VM Scale Set (Node scaling)`),
	Args:  h.RequiredArg("Number (<count>) of nodes (VMs)"),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()
		count := h.IntArgRange(0, "count", 2, 100)

		h.WriteInfo(h.Format("Scaling cluster to '%d' nodes", count))

		h.AzAksCurrentCommand(h.Format("scale -c %d", count))
	},
}

func init() {
	cmd.ScaleCmd.AddCommand(nodesCmd)
}

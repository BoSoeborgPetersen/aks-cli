package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var disableCmd = &c.Command{
	Use:   "disable",
	Short: "Enable node autoscaler",
	Long:  h.Description(`Enable node autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Disable node autoscaler")

		// MaybeDo: Change to string array.
		h.Write(h.AzAksCurrentCommand("update --disable-cluster-autoscaler"))
	},
}

func init() {
	autoscaler.NodeCmd.AddCommand(disableCmd)
}

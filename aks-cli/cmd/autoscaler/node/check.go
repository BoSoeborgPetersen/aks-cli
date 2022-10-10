package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check node autoscaler",
	Long:  h.Description(`Check node autoscaler`),
	Run: func(cmd *c.Command, args []string) {
		h.CheckCurrentCluster()

		h.WriteInfo("Checking node autoscaler")
		h.AzCheckNodeAutoscaler()
		h.WriteInfo("Node autoscaler exists")
	},
}

func init() {
	autoscaler.NodeCmd.AddCommand(checkCmd)
}

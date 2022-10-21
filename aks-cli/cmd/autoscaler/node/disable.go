package node

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/autoscaler"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var disableCmd = &c.Command{
	Use:   "disable",
	Short: "Disable node autoscaler",
	Long:  h.Description(`Disable node autoscaler`),
	Run: h.RunFunctionConvert(DisableFunc),
}

func DisableFunc() {
	h.CheckCurrentCluster()

	h.WriteInfo("Disabling node autoscaler")
	
	h.Write(h.AzAksCurrentCommand("update --disable-cluster-autoscaler"))
}

func init() {
	autoscaler.NodeCmd.AddCommand(disableCmd)
}

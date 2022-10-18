package autoscaler

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var NodeCmd = &c.Command{
	Use:   "node",
	Short: "Setup Autoscaler",
	Long:  h.Description(`Setup automatic Azure VM Scale Set scaling (Node scaling)`),
}

func init() {
	cmd.AutoscalerCmd.AddCommand(NodeCmd)
}

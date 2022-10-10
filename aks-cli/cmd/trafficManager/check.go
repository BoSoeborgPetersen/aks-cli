package trafficManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Azure Traffic Manager",
	Long:  h.Description(`Check Azure Traffic Manager`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	cmd.TrafficManagerCmd.AddCommand(checkCmd)
}

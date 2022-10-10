package trafficManager

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var createCmd = &c.Command{
	Use:   "create",
	Short: "Create Azure Traffic Manager",
	Long:  h.Description(`Create Azure Traffic Manager`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	cmd.TrafficManagerCmd.AddCommand(createCmd)
}

package state

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var verboseCmd = &c.Command{
	Use:   "verbose",
	Short: "Change default Verbose state",
	Long:  h.Description(`Change default Verbose state`),
	Run: func(cmd *c.Command, args []string) {
		disable := h.BoolFlag("disable")

		if !disable {
			h.WriteInfo("Setting global state to verbose output")
		} else {
			h.WriteInfo("Setting global state to non-verbose output")
		}

		h.SetConfigBool(h.GlobalVerboseState, disable)
	},
}

func init() {
	verboseCmd.Flags().BoolP("disable", "d", false, "Flag to disable verbose output")
	cmd.StateCmd.AddCommand(verboseCmd)
}

package state

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var debugCmd = &c.Command{
	Use:   "debug",
	Short: "Change default Debug state",
	Long:  h.Description(`Change default Debug state`),
	Run: func(cmd *c.Command, args []string) {
		disable := h.BoolFlag(cmd, "disable")

		if !disable {
			h.WriteInfo("Setting global state to debug output")
		} else {
			h.WriteInfo("Setting global state to non-debug output")
		}

		h.SetDebuggingState(disable)
	},
}

func init() {
	debugCmd.Flags().BoolP("disable", "d", false, "Flag to disable debug output")
	cmd.StateCmd.AddCommand(debugCmd)
}

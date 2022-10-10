package state

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var whatifCmd = &c.Command{
	Use:   "whatif",
	Short: "Change default WhatIf state",
	Long:  h.Description(`Change default WhatIf state`),
	Run: func(cmd *c.Command, args []string) {
		disable := h.BoolFlag(cmd, "disable")

		if !disable {
			h.WriteInfo("Setting global state to WhatIf (Dry Run) execution")
		} else {
			h.WriteInfo("Setting global state to normal execution")
		}

		h.SetWhatIfState(disable)
	},
}

func init() {
	whatifCmd.Flags().BoolP("disable", "d", false, "Flag to disable WhatIf (Dry Run) execution")
	cmd.StateCmd.AddCommand(whatifCmd)
}

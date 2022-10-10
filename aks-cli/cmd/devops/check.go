package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Azure DevOps (Environment, Pipeline & Service-Connection)",
	Long:  h.Description(`Check Azure DevOps (Environment, Pipeline & Service-Connection)`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	cmd.DevOpsCmd.AddCommand(checkCmd)
}

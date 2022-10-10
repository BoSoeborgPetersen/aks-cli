package pipeline

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check",
	Short: "Check Azure DevOps pipeline",
	Long:  h.Description(`Check Azure DevOps pipeline`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	devops.PipelineCmd.AddCommand(checkCmd)
}

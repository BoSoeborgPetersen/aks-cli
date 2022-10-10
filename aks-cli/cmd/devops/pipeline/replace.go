package pipeline

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace",
	Short: "Replace Azure DevOps pipeline",
	Long:  h.Description(`Replace Azure DevOps pipeline`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	devops.PipelineCmd.AddCommand(replaceCmd)
}

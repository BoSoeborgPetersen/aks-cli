package pipeline

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var deleteCmd = &c.Command{
	Use:   "delete",
	Short: "Delete Azure DevOps pipeline",
	Long:  h.Description(`Delete Azure DevOps pipeline`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Create
	},
}

func init() {
	devops.PipelineCmd.AddCommand(deleteCmd)
}

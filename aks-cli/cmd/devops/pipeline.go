package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var PipelineCmd = &c.Command{
	Use:   "pipeline",
	Short: "Azure DevOps Pipeline operations",
	Long:  h.Description(`Azure DevOps Pipeline operations`),
}

func init() {
	cmd.DevOpsCmd.AddCommand(PipelineCmd)
}

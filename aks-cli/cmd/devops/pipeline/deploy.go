package pipeline

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var DeployCmd = &c.Command{
	Use:   "deploy",
	Short: "Run Azure DevOps pipeline, to deploy application",
	Long:  h.Description(`Run Azure DevOps pipeline, to deploy application`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Rewrite
		h.AzCommand("az devops configure --defaults organization=https://dev.azure.com/3Shape/")
		// h.AzCommand("az pipelines run --name 'MasterData - PreRelease' --project Communicate")
		id := h.AzCommand("az pipelines show --name 'MasterData - PreRelease' --query id --project Communicate")
		h.AzCommand("az pipelines runs list --project Communicate")
		h.AzCommand(h.Format("az pipelines runs show --id %s --project Communicate", id))
		
	},
}

func init() {
	devops.PipelineCmd.AddCommand(DeployCmd)
}

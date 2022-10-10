package environmentChecks

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var showCmd = &c.Command{
	Use:   "show <name>",
	Short: "Show Check for Azure DevOps environment",
	Long:  h.Description(`Show Check for Azure DevOps environment`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		
		h.WriteInfo("Showing Environment Check")
		
		id := h.AzDevOpsEnvironmentId(name)
		
		h.AzDevOpsInvokeQueryF(h.AzDevOpsQueryFlags{ Area: "PipelinesChecks", Resource: "configurations", Parameters: h.Format("resourceType=environment resourceId=%s", id) })
		
		// LIST:
		// GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations?resourceType=environment&resourceId=234
		
		// SHOW:
		// GET https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations/233
	},
}

func init() {
	devops.EnvironmentChecksCmd.AddCommand(showCmd)
}

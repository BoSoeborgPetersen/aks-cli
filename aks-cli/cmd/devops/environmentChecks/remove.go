package environmentChecks

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var removeCmd = &c.Command{
	Use:   "remove <name>",
	Short: "Remove Check from Azure DevOps environment",
	Long:  h.Description(`Remove Check from Azure DevOps environment`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		
		h.WriteInfo("Removing Environment Check")
		
		environmentId := h.AzDevOpsEnvironmentId(name)
		h.CheckVariable(environmentId, "environment id")
		checkId := h.AzDevOpsInvokeQueryF(h.AzDevOpsQueryFlags{ Area: "PipelinesChecks", Resource: "configurations", Parameters: h.Format("resourceType=environment resourceId=%s", environmentId), Query: "value[0].id", Output: "tsv" })
		h.CheckVariable(checkId, "environment check id")
		
		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{ Area: "PipelinesChecks", Resource: "configurations", Parameters: h.Format("id=%s", checkId), MethodHttp: "DELETE" })
		
		// DELETE:
		// DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations/{id}
	},
}

func init() {
	devops.EnvironmentChecksCmd.AddCommand(removeCmd)
}

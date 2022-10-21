package environmentChecks

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <name>",
	Short: "Add Check to Azure DevOps environment",
	Long:  h.Description(`Add Check to Azure DevOps environment`),
	Args:  h.RequiredArg("Environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)

		environmentId := h.AzDevOpsEnvironmentId(name)
		h.WriteInfo("Checking DevOps Environment Check")
		h.AzDevOpsInvokeCheck("PipelinesChecks", "configurations", h.Format("resourceType=environment resourceId=%s", environmentId), h.Format("value[?resource.name=='%s'].resource.name", name), true)
		h.WriteInfo("DevOps Environment Check exists")
	},
}

func init() {
	devops.EnvironmentChecksCmd.AddCommand(checkCmd)
}

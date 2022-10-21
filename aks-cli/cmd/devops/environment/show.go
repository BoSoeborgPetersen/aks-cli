package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var showCmd = &c.Command{
	Use:   "show <name>",
	Short: "Show Azure DevOps environment",
	Long:  h.Description(`Show Azure DevOps environment`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)

		h.WriteInfo("Showing Environment")

		// h.AzDevOpsInvokeQuery(h.AzDevOpsQueryFlags{ Area: "environments", Resource: "environments", Query: h.Format("value[?name=='%s']", name) })
		id := name
		h.AzDevOpsInvokeQueryF(h.AzDevOpsQueryFlags{Area: "environments", Resource: "environments", Parameters: h.Format("environmentId=%s", id)})
	},
}

func init() {
	devops.EnvironmentCmd.AddCommand(showCmd)
}

package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <name>",
	Short: "Check Azure DevOps environment",
	Long:  h.Description(`Check Azure DevOps environment`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)

		h.WriteInfo("Checking DevOps Environment")
		h.AzDevOpsInvokeCheck("environments", "environments", h.Format("value[?name=='%s'].name", name), "", true)
		h.WriteInfo("DevOps Environment exists")
	},
}

func init() {
	checkCmd.Flags().String("name", "", "Environment Name")
	devops.EnvironmentCmd.AddCommand(checkCmd)
}

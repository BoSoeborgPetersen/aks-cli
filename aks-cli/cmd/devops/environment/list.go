package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var listCmd = &c.Command{
	Use:   "list",
	Short: "List Azure DevOps environments",
	Long:  h.Description(`List Azure DevOps environments`),
	Run: func(cmd *c.Command, args []string) {
		h.WriteInfo("List Environments")

		h.AzDevOpsInvokeQueryF(h.AzDevOpsQueryFlags{Area: "environments", Resource: "environments"})
	},
}

func init() {
	devops.EnvironmentCmd.AddCommand(listCmd)
}

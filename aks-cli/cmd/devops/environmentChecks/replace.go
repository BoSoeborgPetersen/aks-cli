package environmentChecks

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace <name>",
	Short: "Replace Azure DevOps environment Check",
	Long:  h.Description(`Replace Azure DevOps environment Check`),
	Args:  h.RequiredArg("Environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringFlag("name")

		h.WriteInfo("Replacing Environment Check")

		removeCmd.Run(cmd, []string{name})
		AddCmd.Run(cmd, []string{name})
	},
}

func init() {
	showCmd.Flags().String("name", "", "Environment Name")
	devops.EnvironmentChecksCmd.AddCommand(replaceCmd)
}

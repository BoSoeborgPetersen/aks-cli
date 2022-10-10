package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var showCmd = &c.Command{
	Use:   "show <name>",
	Short: "Show Azure DevOps Service-Connection",
	Long:  h.Description(`Show Azure DevOps Service-Connection`),
	Args:  h.RequiredArg("Service Connection <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		
		h.WriteInfo("Showing Service Connection")
		
		h.AzDevOpsCommandF("service-endpoint list", h.AzCommandFlags{ Query: h.Format("[?name=='%s']", name) })
	},
}

func init() {
	devops.ServiceConnectionCmd.AddCommand(showCmd)
}

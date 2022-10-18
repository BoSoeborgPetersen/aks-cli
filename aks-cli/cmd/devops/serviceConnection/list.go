package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var listCmd = &c.Command{
	Use:   "list",
	Short: "List Azure DevOps Service-Connections",
	Long:  h.Description(`List Azure DevOps Service-Connections`),
	Run: func(cmd *c.Command, args []string) {
		query := h.StringFlag("query")

		h.WriteInfo("List Service Connections")

		h.AzDevOpsCommandF("service-endpoint list", h.AzFlags{Query: query})
	},
}

func init() {
	listCmd.Flags().String("query", "", "Azure CLI JsonPath Query")
	devops.ServiceConnectionCmd.AddCommand(listCmd)
}

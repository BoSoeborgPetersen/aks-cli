package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var ServiceConnectionCmd = &c.Command{
	Use:   "serviceConnection",
	Short: "Azure DevOps Service-Connection operations",
	Long:  h.Description(`Azure DevOps Service-Connection operations`),
}

func init() {
	cmd.DevOpsCmd.AddCommand(ServiceConnectionCmd)
}

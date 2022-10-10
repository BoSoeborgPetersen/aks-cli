package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var EnvironmentChecksCmd = &c.Command{
	Use:   "environmentChecks",
	Short: "Azure DevOps Environment operations",
	Long:  h.Description(`Azure DevOps Environment operations`),
}

func init() {
	cmd.DevOpsCmd.AddCommand(EnvironmentChecksCmd)
}

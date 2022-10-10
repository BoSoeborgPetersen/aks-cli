package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var EnvironmentCmd = &c.Command{
	Use:   "environment",
	Short: "Azure DevOps Environment Kubernetes resource operations",
	Long:  h.Description(`Azure DevOps Environment Kubernetes resource operations`),
}

func init() {
	cmd.DevOpsCmd.AddCommand(EnvironmentCmd)
}

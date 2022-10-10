package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var EnvironmentKubernetesCmd = &c.Command{
	Use:   "environmentKubernetes",
	Short: "Azure DevOps Environment Checks operations",
	Long:  h.Description(`Azure DevOps Environment Checks operations`),
}

func init() {
	cmd.DevOpsCmd.AddCommand(EnvironmentKubernetesCmd)
}

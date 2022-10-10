package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var replaceCmd = &c.Command{
	Use:   "replace <name>",
	Short: "Replace Azure DevOps environment, possibly with default Kubernetes resources",
	Long:  h.Description(`Replace Azure DevOps environment, possibly with default Kubernetes resources`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		replaceDefaultKubernetesResources := h.BoolFlag(cmd, "replaceDefaultKubernetesResources")

		h.WriteInfo("Replacing Environment")

		if replaceDefaultKubernetesResources {
			deleteCmd.Run(cmd, []string{name, "--addDefaultKubernetesResources"})
			createCmd.Run(cmd, []string{name, "--removeDefaultKubernetesResources"})
		} else {
			deleteCmd.Run(cmd, []string{name})
			createCmd.Run(cmd, []string{name})
		}
	},
}

func init() {
	replaceCmd.Flags().Bool("replaceDefaultKubernetesResources", false, "")
	devops.EnvironmentCmd.AddCommand(replaceCmd)
}

package devops

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"

	// "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/serviceConnection"
	// "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/envionment"
	// "github.com/BoSoeborgPetersen/aks-cli/cmd/devops/pipeline"

	c "github.com/spf13/cobra"
)

// NOWDO: Fix
var replaceClusterCmd = &c.Command{
	Use:   "replaceCluster",
	Short: "Azure DevOps - Replace service-connection, environment and run pipelines",
	Long:  h.Description(`Azure DevOps - Replace service-connection, environment and run pipelines`),
	Run: func(cmd *c.Command, args []string) {
		// TODO: Refactor

		h.WriteInfo("Azure DevOps: Replacing service-connection, environment and running pipelines")

		if h.AreYouSure() {
			// h.AksCommand("devops service-connection replace")
			// serviceConnection.ReplaceCmd.Run(cmd, []string{})
			// h.AksCommand("devops envionment replace-all")
			// environment.replaceAllCmd.Run(cmd, []string{})
			// h.AksCommand("devops pipeline deploy")
			// pipeline.DeployCmd.Run(cmd, []string{})
		}
	},
}

func init() {
	cmd.DevOpsCmd.AddCommand(replaceClusterCmd)
}

package cmd

import (
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var DevOpsCmd = &c.Command{
	Use:   "devops",
	Short: "Azure DevOps operations",
	Long:  h.Description(`Azure DevOps operations`),
	PersistentPreRun: func(cmd *c.Command, args []string) {
		h.AzDevOpsCommand(h.Format("configure --defaults organization=https://dev.azure.com/%s/ project=%s", h.DevOpsOrganizationName(), h.DevOpsProjectName()))
	},
}

func init() {
	rootCmd.AddCommand(DevOpsCmd)
}

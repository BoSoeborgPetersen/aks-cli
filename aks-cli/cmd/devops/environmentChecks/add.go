package environmentChecks

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var AddCmd = &c.Command{
	Use:   "add <name>",
	Short: "Check Azure DevOps environment Check",
	Long:  h.Description(`Check Azure DevOps environment Check`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)
		approver := h.StringFlag("approver")

		h.WriteInfo("Creating Environment")

		id := h.AzDevOpsEnvironmentId(name)
		approverId := h.AzDevOpsCommandF("security group list", h.AzFlags{Query: h.Format("graphGroups[?principalName=='%s'].originId", approver), Output: "tsv"})

		arguments := map[string]interface{}{
			"type": map[string]interface{}{
				"name": "Approval",
			},
			"settings": map[string]interface{}{
				"approvers": []interface{}{
					map[string]interface{}{
						"id": approverId,
					},
				},
				"requesterCannotBeApprover": false,
			},
			"resource": map[string]interface{}{
				"type": "environment",
				"id":   id,
				"name": name,
			},
			"timeout": 43200,
		}

		filepath := h.SaveTempFile(arguments)
		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{Area: "PipelinesChecks", Resource: "configurations", MethodHttp: "POST", Filepath: filepath})
		h.DeleteTempFile(filepath)

		// ADD:
		// POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/checks/configurations
	},
}

func init() {
	AddCmd.Flags().String("approver", "[Identity]\\Contributors", "")
	devops.EnvironmentChecksCmd.AddCommand(AddCmd)
}

package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var DeleteCmd = &c.Command{
	Use:   "delete <name>",
	Short: "Delete Azure DevOps Service-Connection",
	Long:  h.Description(`Delete Azure DevOps Service-Connection`),
	Args:  h.RequiredArg("Service Connection <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		namespace := h.NamespaceFlagCheck(cmd)
		
		h.WriteInfo("Deleting Service Connection")
		
		serviceAccount := h.DevOpsServiceAccountName(name)
		roleBinding := h.DevOpsRoleBindingName(name)
		
		h.KubectlCommandF(h.Format("delete serviceaccount %s", serviceAccount), h.KubectlFlags{ Namespace: namespace })
		h.KubectlCommandF(h.Format("delete rolebinding %s", roleBinding), h.KubectlFlags{ Namespace: namespace })
		
		id := h.AzDevOpsQuery("service-endpoint list", h.AzQueryFlags{ Query: h.Format("[?name=='%s'].id", name), Output: "tsv" })
		h.AzDevOpsCommand(h.Format("service-endpoint delete --id %s -y", id))
	},
}

func init() {
	DeleteCmd.Flags().String("namespace", "default", "Kubernetes namespace")
	devops.ServiceConnectionCmd.AddCommand(DeleteCmd)
}
package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var checkCmd = &c.Command{
	Use:   "check <name>",
	Short: "Check Azure DevOps Service-Connection",
	Long:  h.Description(`Check Azure DevOps Service-Connection`),
	Args:  h.RequiredArg("Service Connection <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := args[0]
		namespace := h.NamespaceFlagCheck(cmd)
		
		serviceAccount := h.DevOpsServiceAccountName(name)
		roleBinding := h.DevOpsRoleBindingName(name)
		
		h.WriteInfo("Checking DevOps Service Connection")
		
		h.WriteInfo("Checking Kubernetes service account")
		h.KubectlCheckF("serviceaccount", serviceAccount, namespace, true)
		h.WriteInfo("Kubernetes service account exists")
		
		h.WriteInfo("Checking Kubernetes role binding")
		h.KubectlCheckF("rolebinding", roleBinding, namespace, true)
		h.WriteInfo("Kubernetes role binding exists")
		
		h.WriteInfo("Checking DevOps service endpoint")
		h.AzDevOpsCheck("service-endpoint", name, namespace, true)
		h.WriteInfo("DevOps service endpoint exists")
		
		h.WriteInfo("DevOps Service Connection exists")
	},
}

func init() {
	checkCmd.Flags().StringP("namespace", "n", "default", "Kubernetes namespace")
	devops.ServiceConnectionCmd.AddCommand(checkCmd)
}

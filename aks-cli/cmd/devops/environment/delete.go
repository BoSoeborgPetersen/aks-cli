package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops/serviceConnection"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var deleteCmd = &c.Command{
	Use:   "delete <name>",
	Short: "Delete Azure DevOps environment, possibly with default Kubernetes resources",
	Long:  h.Description(`Delete Azure DevOps environment, possibly with default Kubernetes resources`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)
		removeDefaultKubernetesResources := h.BoolFlag("removeDefaultKubernetesResources")

		h.WriteInfo("Deleting Environment")

		if removeDefaultKubernetesResources {
			// TODO: Rewrite
			h.WriteInfo(h.Format("Removing Kubernetes resource from DevOps Environment '%s, Namespace: default'", name))
			//h.AksCommand("devops environment remove-kubernetes default")
			serviceConnection.DeleteCmd.Run(cmd, []string{h.Format("%s-default", name), "default"})
			h.WriteInfo(h.Format("Removing Kubernetes resource from DevOps Environment '%s, Namespace: ingress'", name))
			//h.AksCommand("devops environment remove-kubernetes ingress")
			serviceConnection.DeleteCmd.Run(cmd, []string{h.Format("%s-ingress", name), "ingress"})
			h.WriteInfo(h.Format("Removing Kubernetes resource from DevOps Environment '%s, Namespace: cert-manager'", name))
			//h.AksCommand("devops environment remove-kubernetes cert-manager")
			serviceConnection.DeleteCmd.Run(cmd, []string{h.Format("%s-cert-manager", name), "cert-manager"})
		}

		id := h.AzDevOpsEnvironmentId(name)
		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{Area: "environments", Resource: "environments", Parameters: h.Format("environmentId=%s", id), MethodHttp: "DELETE"})

		// DELETE:
		// DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234
	},
}

func init() {
	createCmd.Flags().Bool("removeDefaultKubernetesResources", false, "Remove Kubernetes resources for default namespaces (default, ingress, cert-manager)")
	devops.EnvironmentCmd.AddCommand(deleteCmd)
}

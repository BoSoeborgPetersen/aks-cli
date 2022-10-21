package environment

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops/environmentKubernetes"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var createCmd = &c.Command{
	Use:   "create <name>",
	Short: "Create Azure DevOps environment, possibly with default Kubernetes resources",
	Long:  h.Description(`Create Azure DevOps environment, possibly with default Kubernetes resources`),
	Args:  h.RequiredArg("environment <name>"),
	Run: func(cmd *c.Command, args []string) {
		// LaterDo: Add Approval/Check (e.g. '[Identity]\Contributors')
		name := h.StringArg(0)
		addDefaultKubernetesResources := h.BoolFlag("addDefaultKubernetesResources")

		h.WriteInfo("Creating Environment")

		arguments := map[string]string{"name": name}
		filepath := h.SaveTempFile(arguments)
		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{Area: "environments", Resource: "environments", MethodHttp: "POST", Filepath: filepath})
		h.DeleteTempFile(filepath)

		if addDefaultKubernetesResources {
			h.WriteInfo(h.Format("Adding Kubernetes resource to DevOps Environment '%s, Namespace: default'", name))
			environmentKubernetes.AddCmd.Run(cmd, []string{name, "default"})
			h.WriteInfo(h.Format("Adding Kubernetes resource to DevOps Environment '%s, Namespace: ingress'", name))
			environmentKubernetes.AddCmd.Run(cmd, []string{name, "ingress"})
			h.WriteInfo(h.Format("Adding Kubernetes resource to DevOps Environment '%s, Namespace: cert-manager'", name))
			environmentKubernetes.AddCmd.Run(cmd, []string{name, "cert-manager"})
		}

		// CREATE:
		// POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234
	},
}

func init() {
	createCmd.Flags().Bool("addDefaultKubernetesResources", false, "Add Kubernetes resources for default namespaces (default, ingress, cert-manager)")
	devops.EnvironmentCmd.AddCommand(createCmd)
}

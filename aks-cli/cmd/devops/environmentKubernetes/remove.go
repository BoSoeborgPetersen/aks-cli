package environmentKubernetes

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops/serviceConnection"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var removeCmd = &c.Command{
	Use:   "remove <environment> <namespace>",
	Short: "Remove Kubernetes resource from Azure DevOps environment",
	Long:  h.Description(`Remove Kubernetes resource from Azure DevOps environment`),
	Args: h.RequiredAll(
		h.RequiredArg("<environment> name"),
		h.RequiredArgAt("Kubernetes <namespace>", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		environment := h.StringArg(0)

		h.CheckCurrentCluster()
		namespace := h.NamespaceArgCheck(1)

		environmentId := h.AzDevOpsEnvironmentId(environment)
		resourceId := h.AzDevOpsResourceId(namespace)

		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{Area: "environments", Resource: "kubernetes", Parameters: h.Format("environmentId=%s resourceId=%s", environmentId, resourceId), MethodHttp: "DELETE"})

		var serviceEndpointId string
		for !h.IsSet(serviceEndpointId) {
			serviceEndpointId = h.AzDevOpsQuery("service-endpoint list", h.AzFlags{Query: h.Format("[?name=='%s-%s'].id", environment, namespace), Output: "tsv"})
		}

		serviceConnection.DeleteCmd.Run(cmd, []string{environment, namespace})

		// DELETE:
		// DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes/{id}
	},
}

func init() {
	devops.EnvironmentKubernetesCmd.AddCommand(removeCmd)
}

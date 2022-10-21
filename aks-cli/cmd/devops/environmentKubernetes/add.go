package environmentKubernetes

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops/serviceConnection"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var AddCmd = &c.Command{
	Use:   "add <environment> <namespace>",
	Short: "Add Kubernetes resource to Azure DevOps environment",
	Long:  h.Description(`Add Kubernetes resource to Azure DevOps environment`),
	Args: h.RequiredAll(
		h.RequiredArg("<environment> name"),
		h.RequiredArgAt("Kubernetes <namespace>", 1),
	),
	Run: func(cmd *c.Command, args []string) {
		environment := h.StringArg(0)

		h.CheckCurrentCluster()
		namespace := h.NamespaceArgCheck(1)

		/*serviceEndpoint :=*/
		serviceConnection.CreateCmd.Run(cmd, []string{environment, namespace})
		serviceEndpoint := "lksdjf"

		// NOWDO: Fix
		// serviceEndpointId := serviceEndpoint // | jq -r ' .id' // TODO: Create JqCommand and use it here
		serviceEndpointId := h.JqQuery(serviceEndpoint, ".id")[0] // | jq -r ' .id' // TODO: Create JqCommand and use it here
		for !h.IsSet(serviceEndpointId) {
			serviceEndpointId = h.AzDevOpsQuery("service-endpoint list", h.AzFlags{Query: h.Format("[?name=='%s-%s'].id", environment, namespace), Output: "tsv"})
		}

		arguments := map[string]string{
			"name":              namespace,
			"namespace":         namespace,
			"clusterName":       h.GetGlobalCurrentCluster().Name,
			"serviceEndpointId": serviceEndpointId,
		}

		environmentId := h.AzDevOpsEnvironmentId(environment)

		filepath := h.SaveTempFile(arguments)
		h.AzDevOpsInvokeCommandF(h.AzDevOpsCommandFlags{Area: "environments", Resource: "kubernetes", Parameters: h.Format("environmentId=%s", environmentId), MethodHttp: "POST", Filepath: filepath})
		h.DeleteTempFile(filepath)

		// CREATE:
		// POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234/providers/kubernetes
	},
}

func init() {
	devops.EnvironmentKubernetesCmd.AddCommand(AddCmd)
}

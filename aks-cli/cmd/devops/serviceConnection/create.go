package serviceConnection

import (
	"github.com/BoSoeborgPetersen/aks-cli/cmd/devops"
	h "github.com/BoSoeborgPetersen/aks-cli/helpers"
	c "github.com/spf13/cobra"
)

var CreateCmd = &c.Command{
	Use:   "create <name>",
	Short: "Create Azure DevOps Service-Connection",
	Long:  h.Description(`Create Azure DevOps Service-Connection`),
	Args:  h.RequiredArg("Service Connection <name>"),
	Run: func(cmd *c.Command, args []string) {
		name := h.StringArg(0)

		h.CheckCurrentCluster()
		namespace := h.NamespaceFlagCheck()

		h.WriteInfo("Creating Service Connection")

		project := h.GetConfigString(h.DevOpsProjectName)
		subscription := h.GetGlobalCurrentSubscription().Name
		subscriptionId := h.GetGlobalCurrentSubscription().Id
		subscriptionTenantId := h.GetGlobalCurrentSubscription().TenantId
		cluster := h.GetGlobalCurrentCluster().Name
		clusterFqdn := h.GetGlobalCurrentCluster().Fqdn
		resourceGroup := h.GetGlobalCurrentCluster().ResourceGroup

		// $serviceAccount = DevOpsServiceAccountName() $name
		// $roleBinding = DevOpsRoleBindingName() $name

		// KubectlCommand() "create serviceaccount $serviceAccount" -n $namespace
		// KubectlCommand() "create rolebinding $roleBinding --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccount`"" -n $namespace

		// $secret = KubectlQuery() "get serviceaccount $serviceAccount" -n $namespace -j '{.secrets[0].name}'

		arguments := map[string]interface{}{
			"authorization": map[string]interface{}{
				"parameters": map[string]interface{}{
					"azureEnvironment": "AzureCloud",
					"azureTenantId":    subscriptionTenantId,
					// "roleBindingName": roleBinding,
					// "secretName": secret,
					// "serviceAccountName": serviceAccount,
				},
				"scheme": "Kubernetes",
			},
			"name":        name,
			"description": h.Format("Connection to %s", cluster),
			"type":        "kubernetes",
			"url":         h.Format("https://%s", clusterFqdn),
			"data": map[string]interface{}{
				"authorizationType":     "AzureSubscription",
				"azureSubscriptionId":   subscriptionId,
				"azureSubscriptionName": subscription,
				"clusterId":             h.Format("/subscriptions/%s/resourcegroups/%s/providers/Microsoft.ContainerService/managedClusters/%s", subscriptionId, resourceGroup, cluster),
				"namespace":             namespace,
			},
			"isShared": "false",
			"serviceEndpointProjectReferences": []interface{}{
				map[string]interface{}{
					"name":        name,
					"description": h.Format("Connection to %s", cluster),
					"projectReference": map[string]interface{}{
						"id":   "dd3cb1a2-3bd9-414d-86f1-06be48fbfd01",
						"name": project,
					},
				},
			},
			"owner": "Library",

			// "administratorsGroup": null,
			// "groupScopeId": null,
			// "operationStatus": null,
			// "readersGroup": null,
		}

		filepath := h.SaveTempFile(arguments)
		h.AzDevOpsCommand(h.Format("service-endpoint create --service-endpoint-configuration %s", filepath))
		h.DeleteTempFile(filepath)

		// AzDevOpsCommand() "service-endpoint azurerm create --azure-rm-service-principal-id $ServicePrincipal --azure-rm-subscription-id $SubscriptionId --azure-rm-subscription-name $SubscriptionName --name $SubscriptionName --azure-rm-tenant-id $TenantId --project $ProjectName --org $Organization"
	},
}

func init() {
	CreateCmd.Flags().StringP("namespace", "n", "default", "Kubernetes namespace")
	devops.ServiceConnectionCmd.AddCommand(CreateCmd)
}

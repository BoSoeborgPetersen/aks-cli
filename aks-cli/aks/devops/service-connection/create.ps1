param($name, $namespace = "default")

WriteAndSetUsage ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

CheckCurrentCluster
CheckVariable $name "name"
KubectlCheckNamespace $namespace

Write-Info "Creating Service Connection"

$project = DevOpsProjectName
$subscription = CurrentSubscriptionName
$subscriptionId = CurrentSubscription
$subscriptionTenantId = CurrentSubscriptionTenantId
$cluster = CurrentClusterName
$clusterFqdn = CurrentClusterFqdn
$resourceGroup = CurrentClusterResourceGroup

# $serviceAccount = DevOpsServiceAccountName $name
# $roleBinding = DevOpsRoleBindingName $name

# KubectlCommand "create serviceaccount $serviceAccount" -n $namespace
# KubectlCommand "create rolebinding $roleBinding --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccount`"" -n $namespace

# $secret = KubectlQuery "get serviceaccount $serviceAccount" -n $namespace -j '{.secrets[0].name}'

$arguments=@{
    authorization = @{
        parameters = @{
            azureEnvironment = "AzureCloud"
            azureTenantId = $subscriptionTenantId
            # roleBindingName = $roleBinding
            # secretName = $secret
            # serviceAccountName = $serviceAccount
        }
        scheme = "Kubernetes"
    }
    name = "$name"
    description = "Connection to $cluster"
    type = "kubernetes"
    url = "https://$clusterFqdn"
    data = @{
        authorizationType = "AzureSubscription"
        azureSubscriptionId = $subscriptionId
        azureSubscriptionName = $subscription
        clusterId = "/subscriptions/$subscriptionId/resourcegroups/$resourceGroup/providers/Microsoft.ContainerService/managedClusters/$cluster"
        namespace = $namespace
    }
    isShared = "false"
    serviceEndpointProjectReferences = @(
        @{
          name = "$name"
          description = "Connection to $cluster"
          projectReference = @{
            id = "dd3cb1a2-3bd9-414d-86f1-06be48fbfd01"
            name = "$project"
          }
        }
    )
    owner = "Library"

    # administratorsGroup = null
    # groupScopeId = null
    # operationStatus = null
    # readersGroup = null
}

$filepath = SaveTempFile($arguments)
AzDevOpsCommand "service-endpoint create --service-endpoint-configuration $filepath"
DeleteTempFile($filepath)
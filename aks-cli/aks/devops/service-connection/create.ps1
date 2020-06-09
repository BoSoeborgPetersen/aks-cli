param($name, $namespace = "default")

WriteAndSetUsage "aks devops service-connection create" ([ordered]@{
    "<name>" = "Service Connection Name"
    "[namespace]" = "Kubernetes namespace"
})

CheckCurrentCluster
CheckVariable $name "name"
KubectlCheckNamespace $namespace

Write-Info "Creating Service Connection"

$subscription = CurrentSubscriptionName
$subscriptionId = CurrentSubscription
$subscriptionTenantId = CurrentSubscriptionTenantId
$cluster = CurrentClusterName
$clusterFqdn = CurrentClusterFqdn
$resourceGroup = CurrentClusterResourceGroup

$serviceAccount = DevOpsServiceAccountName $name
$roleBinding = DevOpsRoleBindingName $name

KubectlCommand "create serviceaccount $serviceAccount" -n $namespace
KubectlCommand "create rolebinding $roleBinding --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccount`"" -n $namespace

$secret = KubectlQuery "get serviceaccount $serviceAccount" -n $namespace -j '{.secrets[0].name}'

$arguments=@{
    authorization = @{
        parameters = @{
            azureEnvironment = "AzureCloud"
            azureTenantId = $subscriptionTenantId
            roleBindingName = $roleBinding
            secretName = $secret
            serviceAccountName = $serviceAccount
        }
        scheme = "Kubernetes"
    }
    name = "$name-$namespace"
    type = "kubernetes"
    url = "https://$clusterFqdn"
    data = @{
        authorizationType = "AzureSubscription"
        azureSubscriptionId = $subscriptionId
        azureSubscriptionName = $subscription
        clusterId = "/subscriptions/$subscriptionId/resourcegroups/$resourceGroup/providers/Microsoft.ContainerService/managedClusters/$cluster"
        namespace = $namespace
    }
    isShared = "true"
    owner = "Library"
}

$filepath = SaveTempFile($arguments)
AzDevOpsCommand "service-endpoint create --service-endpoint-configuration $filepath"
DeleteTempFile($filepath)
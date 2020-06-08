# LaterDo: Rewrite
param($name, $namespace)

WriteAndSetUsage "aks devops service-connection create <name> [namespace]"

CheckVariable $name "name"
SetDefaultIfEmpty ([ref]$namespace) "default"

$subscriptionId = GetCurrentSubscription
$subscriptionName = GetCurrentSubscriptionName
$subscriptionTenantId = GetCurrentSubscriptionTenantId
$subscriptionFqdn = GetCurrentSubscriptionFqdn
CheckCurrentCluster
$cluster = GetCurrentClusterName
$resourceGroup = GetCurrentClusterResourceGroup
$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Create Service Account
KubectlCommand "create serviceaccount $serviceAccountName" -n $namespace
# Create Role Binding
KubectlCommand "create rolebinding $roleBindingName --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccountName`"" -n $namespace

$secretName = KubectlQuery "get serviceaccount $serviceAccountName" -n $namespace -o "jsonpath='{.secrets[0].name}'"

$arguments=@{
    "authorization" = @{
        "parameters" = @{
            "azureEnvironment" = "AzureCloud"
            "azureTenantId" = $subscriptionTenantId
            "roleBindingName" = $roleBindingName
            "secretName" = $secretName
            "serviceAccountName" = $serviceAccountName
        }
        "scheme" = "Kubernetes"
    }
    "name" = $name
    "type" = "kubernetes"
    "url" = ("https://$subscriptionFqdn")
    "data" = @{
        "authorizationType" = "AzureSubscription"
        "azureSubscriptionId" = $subscriptionId
        "azureSubscriptionName" = $subscriptionName
        "clusterId" = "/subscriptions/$subscriptionId/resourcegroups/$resourceGroup/providers/Microsoft.ContainerService/managedClusters/$cluster"
        "namespace" = "$namespace"
    }
    "isShared" = "true"
    "owner" = "Library"
}

$json = $arguments | ConvertTo-Json
Write-Verbose $json
$json | Out-File -FilePath ~/azure-devops-service-connection-create.json
AzCommand "devops service-endpoint create --service-endpoint-configuration ~/azure-devops-service-connection-create.json"
Remove-Item ~/azure-devops-service-connection-create.json






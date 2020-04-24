param($name, $namespace)

WriteAndSetUsage "aks devops service-connection create <name> [namespace]"

VerifyVariable $name "name"
SetDefaultIfEmpty ([ref]$namespace) "default"
$namespaceString = KubectlNamespaceString $namespace

$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Create Service Account
ExecuteCommand ("kubectl create serviceaccount $serviceAccountName $namespaceString $kubeDebugString")
# Create Role Binding
ExecuteCommand ("kubectl create rolebinding $roleBindingName --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccountName`" $namespaceString $kubeDebugString")

$secretName = ExecuteQuery ("kubectl get serviceaccount $serviceAccountName $namespaceString -o jsonpath='{.secrets[0].name}' $kubeDebugString")

$arguments=@{
    "authorization" = @{
        "parameters" = @{
            "azureEnvironment" = "AzureCloud"
            "azureTenantId" = $GlobalCurrentSubscription.TenantId
            "roleBindingName" = $roleBindingName
            "secretName" = $secretName
            "serviceAccountName" = $serviceAccountName
        }
        "scheme" = "Kubernetes"
    }
    "name" = $name
    "type" = "kubernetes"
    "url" = ("https://$($GlobalCurrentCluster.Fqdn)")
    "data" = @{
        "authorizationType" = "AzureSubscription"
        "azureSubscriptionId" = $GlobalCurrentSubscription.Id
        "azureSubscriptionName" = $GlobalCurrentSubscription.Name
        "clusterId" = "/subscriptions/$($GlobalCurrentSubscription.Id)/resourcegroups/$($GlobalCurrentCluster.ResourceGroup)/providers/Microsoft.ContainerService/managedClusters/$($GlobalCurrentCluster.Name)"
        "namespace" = "$namespace"
    }
    "isShared" = "true"
    "owner" = "Library"
}

$json = $arguments | ConvertTo-Json
Write-Verbose $json
$json | Out-File -FilePath ~/azure-devops-service-connection-create.json
ExecuteCommand ("az devops service-endpoint create --service-endpoint-configuration ~/azure-devops-service-connection-create.json $debugString")
Remove-Item ~/azure-devops-service-connection-create.json






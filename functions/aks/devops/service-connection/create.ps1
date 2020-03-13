param($name, $namespace)

$usage = Write-Usage "aks devops service-connection create <name>"

VerifyVariable $usage $name "name"

SetDefaultIfEmpty ([ref]$namespace) "default"

$unixName = ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
$serviceAccountName = "$unixName-devops-sa"
$roleBindingName = "$unixName-devops-rb"

# Create Service Account
ExecuteCommand ("kubectl create serviceaccount $serviceAccountName -n $namespace $kubeDebugString")
# Create Role Binding
ExecuteCommand ("kubectl create rolebinding $roleBindingName --clusterrole cluster-admin --serviceaccount=`"$namespace`":`"$serviceAccountName`" -n $namespace $kubeDebugString")

$secretName = ExecuteQuery ("kubectl get serviceaccount $serviceAccountName -n $namespace -o jsonpath='{.secrets[0].name}' $kubeDebugString")

$arguments=@{
    "authorization" = @{
        "parameters" = @{
            "azureEnvironment" = "AzureCloud"
            "azureTenantId" = $selectedAccount.TenantId
            "roleBindingName" = $roleBindingName
            "secretName" = $secretName
            "serviceAccountName" = $serviceAccountName
        }
        "scheme" = "Kubernetes"
    }
    "name" = $name
    "type" = "kubernetes"
    "url" = ("https://$($selectedCluster.Fqdn)")
    "data" = @{
        "authorizationType" = "AzureSubscription"
        "azureSubscriptionId" = $selectedAccount.Id
        "azureSubscriptionName" = $selectedAccount.Name
        "clusterId" = "/subscriptions/$($selectedAccount.Id)/resourcegroups/$($selectedCluster.ResourceGroup)/providers/Microsoft.ContainerService/managedClusters/$($selectedCluster.Name)"
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






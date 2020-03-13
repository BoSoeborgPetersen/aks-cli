# TODO: Refactor.
param($resourceGroupName)

$usage = Write-Usage "aks credentials get-clean <resource group name>"

VerifyVariable $usage $resourceGroupName "resource group name"

$clusterName = ResourceGroupToClusterName $resourceGroupName

$contexts = ExecuteQuery "kubectl config get-contexts -o=name $kubeDebugString"

if ($contexts.Where({ $_ -eq $clusterName }, 'First').Count -gt 0)
{
    $newContext = $contexts.Where({ $_ -notlike $clusterName }) | Select-Object -Last 1

    ExecuteCommand "kubectl config use-context $newContext $kubeDebugString"
    ExecuteCommand "kubectl config delete-context $clusterName $kubeDebugString"
    ExecuteCommand "kubectl config delete-cluster $clusterName $kubeDebugString"

    $username = "users.clusterUser_$resourceGroupName_$clusterName"
    
    ExecuteCommand "kubectl config unset $username $kubeDebugString"
}    

ExecuteCommand "az aks get-credentials -g $resourceGroupName -n $clusterName $debugString"
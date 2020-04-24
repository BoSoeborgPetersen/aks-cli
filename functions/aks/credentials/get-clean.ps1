param($resourceGroup)

WriteAndSetUsage "aks credentials get-clean <resource group>"

VerifyVariable $resourceGroup "resource group"

$clusterName = ResourceGroupToClusterName $resourceGroup

$contexts = ExecuteQuery "kubectl config get-contexts -o=name $kubeDebugString"

if ($contexts.Where({ $_ -eq $clusterName }, 'First').Count -gt 0)
{
    ExecuteCommand "kubectl config unset current-context $kubeDebugString"

    ExecuteCommand "kubectl config delete-context $clusterName $kubeDebugString"
    ExecuteCommand "kubectl config delete-cluster $clusterName $kubeDebugString"

    $username = "users.clusterUser_$resourceGroupName_$clusterName"
    
    ExecuteCommand "kubectl config unset $username $kubeDebugString"
}    

ExecuteCommand "az aks get-credentials -g $resourceGroup -n $clusterName $debugString"
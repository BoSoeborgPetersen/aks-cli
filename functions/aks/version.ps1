WriteAndSetUsage "aks version"

VerifyCurrentCluster

Write-Info "Current AKS cluster version"

ExecuteQuery "az aks show -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query 'kubernetesVersion' -o tsv $debugString"
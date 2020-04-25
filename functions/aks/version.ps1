WriteAndSetUsage "aks version"

CheckCurrentCluster

Write-Info "Current AKS cluster version"

ExecuteCommand "az aks show -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query 'kubernetesVersion' -o tsv $debugString"
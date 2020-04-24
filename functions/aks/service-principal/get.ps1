WriteAndSetUsage "aks service-principal get"

CheckCurrentCluster

Write-Info "Get current AKS cluster service principal"

ExecuteCommand "az aks show -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query servicePrincipalProfile.clientId -o tsv $debugString"
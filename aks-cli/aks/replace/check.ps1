# LaterDo: Add (cloud-services, communicate, identity) parameter, that causes more checks
param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, [switch] $useServicePrincipal)

WriteAndSetUsage "aks replace check" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<location>" = AzureLocationDescription
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[loadBalancerSku]" = "Azure Load Balancer SKU (basic, standard)"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

Write-Info "Checking AKS cluster replacement"

Write-Info "Checking AKS cluster setup"
AksCommand setup check $resourceGroup $location $globalSubscription $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku 

# TODO: Add DevOps and Traffic-Manager checks
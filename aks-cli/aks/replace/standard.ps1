param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, [switch] $useServicePrincipal)

WriteAndSetUsage ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<location>" = AzureLocationDescription
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[loadBalancerSku]" = "Azure Load Balancer SKU (basic, standard)"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

AksCommand setup standard $resourceGroup $location $globalSubscription $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku 

# TODO: Add DevOps and Traffic-Manager operations

# # DevOps
# $cluster = ClusterName -resourceGroup $resourceGroup
# # aks service-principal replace
# AksCommand devops environment create $cluster

# # Traffic Managers (redirect traffic)
# # AksCommand traffic-manager replace-endpoint
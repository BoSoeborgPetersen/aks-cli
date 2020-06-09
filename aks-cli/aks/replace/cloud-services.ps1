param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, $windowsAdminUsername, $windowsAdminPassword, $windowsNodeCount, $windowsNodeSize, $windowsNodepool, [switch] $useServicePrincipal)

WriteAndSetUsage "aks replace cloud-services" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<location>" = AzureLocationDescription
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[loadBalancerSku]" = "Azure Load Balancer SKU (basic, standard)"
    "[windowsAdminUsername]" = ""
    "[windowsAdminPassword]" = ""
    "[windowsNodeCount]" = ""
    "[windowsNodeSize]" = ""
    "[windowsNodepool]" = ""
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

AksCommand setup cloud-services $resourceGroup $location $globalSubscription $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku $windowsAdminUsername $windowsAdminPassword $windowsNodeCount $windowsNodeSize $windowsNodepool $useServicePrincipal

# TODO: Add DevOps and Traffic-Manager operations
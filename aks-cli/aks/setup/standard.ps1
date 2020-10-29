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

# WantToContinue "Create Azure Resource Group '$resourceGroup', in location '$location'"
# AksCommand resource-group create $resourceGroup $location

# WantToContinue "Create AKS cluster, in resource group '$resourceGroup'"
# AksCommand create standard $resourceGroup $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku $useServicePrincipal

WantToContinue "Authorize AKS cluster Managed Identity to access global resources (cluster Resource Group & Azure Container Registry) in subscription '$globalSubscription'"
AksCommand identity authorize $globalSubscription

WantToContinue "Install Kured (KUbernetes REboot Daemon) (Helm chart)"
AksCommand kured install

WantToContinue "Install Nginx (Helm chart), with Azure public ip"
AksCommand nginx install -addIp

WantToContinue "Install Certificate Manager (Helm chart)"
AksCommand cert-manager install

WantToContinue "Create Azure Operational Insights Workspace and attach it to the AKS cluster"
AksCommand insights install
# TODO: Test
param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, $windowsAdminUsername, $windowsAdminPassword, $windowsNodeCount, $windowsNodeSize, $windowsNodepool, [switch] $useServicePrincipal)

WriteAndSetUsage ([ordered]@{
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

WantToContinue "Create Azure Resource Group '$resourceGroup', in location '$location'"
AksCommand resource-group create -name $resourceGroup -location $location

WantToContinue "Create AKS cluster, in resource group '$resourceGroup'"
AksCommand create windows -resourceGroup $resourceGroup -minNodeCount $minNodeCount -maxNodeCount $maxNodeCount -nodeSize $nodeSize -loadBalancerSku $loadBalancerSku -windowsAdminUsername $windowsAdminUsername -windowsAdminPassword $windowsAdminPassword -windowsNodeCount $windowsNodeCount -windowsNodeSize $windowsNodeSize -windowsNodepool $windowsNodepool $useServicePrincipal

WantToContinue "Authorize AKS cluster Managed Identity to access global resources (cluster Resource Group & Azure Container Registry) in subscription '$globalSubscription'"
AksCommand identity authorize $globalSubscription

WantToContinue "Install Kured (KUbernetes REboot Daemon) (Helm chart)"
AksCommand kured install

WantToContinue "Install Nginx (Helm chart), with Azure public ip"
AksCommand nginx install -addIp

WantToContinue "Install Certificate Manager (Helm chart)"
AksCommand cert-manager install

# TODO: AksCommand "monitoring install"

WantToContinue "Create Azure Operational Insights Workspace and attach it to the AKS cluster"
AksCommand insights install
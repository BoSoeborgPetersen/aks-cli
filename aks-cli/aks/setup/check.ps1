# LaterDo: Add (cloud-services, communicate, identity) parameter, that causes more checks
param($resourceGroup, $location, $globalSubscription, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, [switch] $useServicePrincipal)

WriteAndSetUsage "aks setup check" ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "<location>" = AzureLocationDescription
    "<globalSubscription>" = "Azure Subscription for global resources (cluster Resource Group & Azure Container Registry)"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[loadBalancerSku]" = "Azure Load Balancer SKU (basic, standard)"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

Write-Info "Checking AKS cluster setup"

Write-Info "Checking resource group"
AksCommand resource-group check $resourceGroup $location

Write-Info "Checking AKS cluster creation"
AksCommand create check $resourceGroup $minNodeCount $maxNodeCount $nodeSize $loadBalancerSku $useServicePrincipal

Write-Info "Checking that AKS cluster managed identity is authorized to access global resources (cluster Resource Group & Azure Container Registry) in subscription '$globalSubscription'"
AksCommand identity check $globalSubscription

Write-Info "Checking Kured (KUbernetes REboot Daemon) (Helm chart)"
AksCommand kured check

Write-Info "Checking Nginx (Helm chart)"
AksCommand nginx check

Write-Info "Checking Certificate Manager (Helm chart)"
AksCommand cert-manager check

Write-Info "Checking Azure Operational Insights Workspace"
AksCommand insights check
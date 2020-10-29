# LaterDo: Add windows parameter, that causes more checks
param($resourceGroup, $minNodeCount = 3, $maxNodeCount = 20, $nodeSize, $loadBalancerSku = "basic", [switch] $useServicePrincipal)

WriteAndSetUsage ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

Write-Info "Checking AKS cluster"
CheckCurrentCluster
Write-Info "AKS cluster exists"

# Check cluster exists
# - Check location
# - Check version
# - Check node size
# - Check load balancer sku
# - Check Service Principal or Managed Identity
# - Check autoscaler enabled # aks autoscaler node check
#   - Check min node count
#   - Check max node count
# - Check switch to cluster
# LaterDo: When dependant resources does not exists, help with solution (resource group does not exist => create with "aks resource-group create $resourceGroup <location>")
param($resourceGroup, $minNodeCount = 3, $maxNodeCount = 20, $nodeSize, $loadBalancerSku = "basic", [switch] $useServicePrincipal)

WriteAndSetUsage ([ordered]@{
    "<resourceGroup>" = "Azure Resource Group"
    "[minNodeCount]" = "Autoscaler Minimum Node Count (default: 3)"
    "[maxNodeCount]" = "Autoscaler Maximum Node Count (default: 20)"
    "[nodeSize]" = "Azure VM Node Size (default: 'Standard_D2s_v3')"
    "[-useServicePrincipal]" = "Use Service Principal instead of Managed Identity"
})

AzCheckResourceGroup $resourceGroup
CheckNumberRange $minNodeCount "min node count" -min 2 -max 100
CheckNumberRange $maxNodeCount "max node count" -min 2 -max 100
AzCheckVirtualMachineSize $nodeSize
AzCheckLoadBalancerSku $loadBalancerSku

$cluster = ClusterName -resourceGroup $resourceGroup
$location = AzQuery "group show -g $resourceGroup" -q location -o tsv
$version = AzAksQuery "get-versions" -l $location -q "orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]" -o tsv

$nodeSizeString = ConditionalOperator $nodeSize "-s '$nodeSize'"

# LaterDo: Check if Service Principal already exists and if so, delete it.

$servicePrincipalString = "--enable-managed-identity"

if ($useServicePrincipal)
{
    $servicePrincipal = ServicePrincipalName -cluster $cluster

    $servicePrincipalObject = (AzCommand "ad sp create-for-rbac -n $servicePrincipal --years 300 --skip-assignment") | ConvertFrom-Json

    $servicePrincipalString = "--service-principal $($servicePrincipalObject.AppId) --client-secret '$($servicePrincipalObject.Password)'"
}

AzAksCommand "create -g $resourceGroup -n $cluster -k $version $nodeSizeString $servicePrincipalString --load-balancer-sku $loadBalancerSku --no-ssh-key --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount"

Write-Info "Cluster has been created, switching cluster"
SwitchCurrentClusterTo $resourceGroup
# TODO: When dependant resources does not exists, help with solution (resource group does not exist => create with "aks resource-group create $resourceGroup <location>")
param($resourceGroup, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku)

WriteAndSetUsage "aks create standard <resource group> [min node count] [max node count] [node size] [load balancer sku]"

AzCheckResourceGroup $resourceGroup
CheckNumberRange ([ref]$minNodeCount) "min node count" -min 2 -max 100 -default 3
CheckNumberRange ([ref]$maxNodeCount) "max node count" -min 2 -max 100 -default 20
AzCheckVirtualMachineSize ([ref]$nodeSize) -default ""
AzCheckLoadBalancerSku ([ref]$loadBalancerSku) -default basic

$clusterName = ResourceGroupToClusterName $resourceGroup
$location = AzQuery "group show -g $resourceGroup" -q location -o tsv
$version = AzAksQuery "get-versions" -l $location -q "'orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]'" -o tsv

$nodeSizeString = ConditionalOperator $nodeSize "-s '$nodeSize'"

# TODO: Check if Service Principal already exists and if so, delete it.

$bugFixed = $true # Service Principal should be created when the cluster is created, but this does not work currently.

# $servicePrincipalString = ""
$servicePrincipalString = "--enable-managed-identity"

if(!$bugFixed)
{
    # $keyVaultName = ResourceGroupToKeyVaultName $resourceGroup
    # $servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
    # $servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName
    
    # AzCheckServicePrincipal($keyVaultName, $servicePrincipalIdName)
    
    # $servicePrincipalId = AzQuery "keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName" -q value
    # $servicePrincipalPassword = AzQuery "keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName" -q value
    
    # $servicePrincipalString = "--service-principal $servicePrincipalId --client-secret $servicePrincipalPassword"

    $servicePrincipalName = ClusterToServicePrincipalName $clusterName

    $servicePrincipal = (AzCommand "ad sp create-for-rbac -n $servicePrincipalName --skip-assignment") | ConvertFrom-Json

    $servicePrincipalString = "--service-principal $($servicePrincipal.AppId) --client-secret '$($servicePrincipal.Password)'"
}

AzAksCommand "create -g $resourceGroup -n $clusterName -k $version $nodeSizeString $servicePrincipalString --load-balancer-sku $loadBalancerSku --no-ssh-key --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount"

Write-Info "Cluster has been created, switching cluster."
SwitchCurrentClusterTo $resourceGroup
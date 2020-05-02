# TODO: When dependant resources does not exists, help with solution (resource group does not exist => create with "aks resource-group create $resourceGroup <location>")
param($resourceGroup, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku, $windowsAdminUsername, $windowsAdminPassword, $windowsNodeCount, $windowsNodeSize, $windowsNodepoolName)

WriteAndSetUsage "aks create windows <resource group> [min node count] [max node count] [node size] [load balancer sku] <windows admin username> <windows admin password> [windows node count] [windows node size] [windows nodepool name]"

AzCheckResourceGroup $resourceGroup
CheckNumberRange ([ref]$minNodeCount) "min node count" -min 2 -max 100 -default 3
CheckNumberRange ([ref]$maxNodeCount) "max node count" -min 2 -max 100 -default 20
CheckVariable $windowsAdminUsername "windows admin username"
CheckVariable $windowsAdminPassword "windows admin password"
CheckNumberRange ([ref]$windowsNodeCount) "windows node count" -min 2 -max 100 -default 2
AzCheckVirtualMachineSize ([ref]$nodeSize) -default ""
AzCheckLoadBalancerSku ([ref]$loadBalancerSku) -default basic

SetDefaultIfEmpty ([ref]$windowsNodeSize) "Standard_H8"
SetDefaultIfEmpty ([ref]$windowsNodepoolName) 'winvms'

$clusterName = ResourceGroupToClusterName $resourceGroup
$location = AzQuery "group show -g $resourceGroup" -q location -o tsv
$version = AzAksQuery "get-versions" -l $location -q 'orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]' -o tsv

$nodeSizeString = ConditionalOperator $nodeSize "-s '$nodeSize'"

# TODO: Check if Service Principal already exists and if so, delete it.

$bugFixed = $true # Service Principal should be created when the cluster is created, but this does not work currently.

$servicePrincipalString = "--enable-managed-identity"

if(!$bugFixed)
{
    # $keyVaultName = ResourceGroupToKeyVaultName $resourceGroup
    # $servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
    # $servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName
    
    # AzCheckServicePrincipal($keyVaultName, $servicePrincipalIdName)
    
    # $servicePrincipalId = AzQuery "keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName --query value"
    # $servicePrincipalPassword = AzQuery "keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName --query value"
    
    # $servicePrincipalString = "--service-principal $servicePrincipalId --client-secret $servicePrincipalPassword"

    $servicePrincipalName = ClusterToServicePrincipalName $clusterName

    $servicePrincipal = AzCommand "ad sp create-for-rbac -n $servicePrincipalName --skip-assignment" | ConvertFrom-Json

    $servicePrincipalString = "--service-principal $($servicePrincipal.AppId) --client-secret $($servicePrincipal.Password)"
}

$windowsParams = "--windows-admin-password $windowsAdminPassword --windows-admin-username $windowsAdminUsername --network-plugin azure"

AzAksCommand "create -g $resourceGroup -n $clusterName -k $version $nodeSizeString $servicePrincipalString --load-balancer-sku $loadBalancerSku --no-ssh-key --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount $windowsParams"
AzAksCommand "nodepool add --cluster-name $clusterName -n $windowsNodepoolName -g $resourceGroup -c $windowsNodeCount -s $windowsNodeSize -k $version --os-type Windows"

Write-Info "Cluster has been created, switching cluster."
SwitchCurrentClusterTo $resourceGroup
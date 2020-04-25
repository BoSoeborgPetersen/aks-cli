# TODO: When dependant resources does not exists, help with solution (resource group does not exist => create with "aks resource-group create $resourceGroup <location>")
param($resourceGroup, $minNodeCount, $maxNodeCount, $nodeSize, $loadBalancerSku)

WriteAndSetUsage "aks create standard <resource group> [min node count] [max node count] [node size] [load balancer sku]"

CheckResourceGroupExists $resourceGroup
CheckNumberRange ([ref]$minNodeCount) "min node count" -min 2 -max 100 -default 3
CheckNumberRange ([ref]$maxNodeCount) "max node count" -min 2 -max 100 -default 20
CheckVirtualMachineSizeExists $nodeSize -default ""
CheckLoadBalancerSkuExists $loadBalancerSku -default basic

$clusterName = ResourceGroupToClusterName $resourceGroup
$location = ExecuteQuery "az group show -g $resourceGroup --query location -o tsv $debugString"
$version = ExecuteQuery "az aks get-versions -l $location --query 'orchestrators[?!isPreview].orchestratorVersion | sort(@) | [-1]' -o tsv $debugString"

$nodeSizeString = ConditionalOperator $nodeSize "-s '$nodeSize'"

$bugFixed = $false # Service Principal should be created when the cluster is created, but this does not work currently.

$servicePrincipalString = ""

if(!$bugFixed)
{
    $keyVaultName = ResourceGroupToKeyVaultName $resourceGroup
    $servicePrincipalIdName = ClusterToServicePrincipalIdName $clusterName
    $servicePrincipalPasswordName = ClusterToServicePrincipalPasswordName $clusterName
    
    CheckServicePrincipalExists($keyVaultName, $servicePrincipalIdName)
    
    $servicePrincipalId = ExecuteQuery "az keyvault secret show -n $servicePrincipalIdName --vault-name $keyVaultName --query value $debugString"
    $servicePrincipalPassword = ExecuteQuery "az keyvault secret show -n $servicePrincipalPasswordName --vault-name $keyVaultName --query value $debugString"
    
    $servicePrincipalString = "--service-principal $servicePrincipalId --client-secret $servicePrincipalPassword"
}

ExecuteCommand "az aks create -g $resourceGroup -n $clusterName -k $version $nodeSizeString $servicePrincipalString --load-balancer-sku $loadBalancerSku --generate-ssh-keys --enable-cluster-autoscaler --min-count $minNodeCount --max-count $maxNodeCount $debugString"

# On success:
# TODO: Ask "do you want to switch to the new AKS cluster?" with prompt.
# TODO: or just switch to new cluster after it is created successfully.
# TODO: Clear the global list of clusters for the subscription.
$clusterNamePostFix = "-aks"
function ResourceGroupToClusterName($resourceGroupName)
{
    return $resourceGroupName+$clusterNamePostFix
}

$insightsNamePostFix = "-aks-insights"
function ResourceGroupToInsightsName($resourceGroupName)
{
    return $resourceGroupName+$insightsNamePostFix
}

$registryPreFix = "gl-"
$registryPostFix = "-acr"
function ResourceGroupToRegistryName($resourceGroupName)
{
    $middle = $resourceGroupName.Split('-')[1]
    return $registryPreFix+$middle+$registryPostFix
}

$keyvaultPreFix = "gl-"
$keyvaultPostFix = "-aks-vault"
function ResourceGroupToKeyVaultName($resourceGroupName)
{
    $middle = $resourceGroupName.Split('-')[1]
    return $keyvaultPreFix+$middle+$keyvaultPostFix
}

$globalResourceGroupPreFix = "gl-"
function ResourceGroupToGlobalResourceGroupName($resourceGroupName)
{
    $middle = $resourceGroupName.Split('-')[1]
    return $globalResourceGroupPreFix+$middle
}

$ipAddressPostFix = "-ip"
function ClusterToIpAddressName($clusterName)
{
    return PrependWithDash ($clusterName+$ipAddressPostFix) $deploymentName
}

$servicePrincipalPreFix = "http://"
$servicePrincipalPostFix = "-principal"
function ClusterToServicePrincipalName($clusterName)
{
    return $servicePrincipalPreFix+$clusterName+$servicePrincipalPostFix
}

$servicePrincipalIdPostFix = "-principal-id"
function ClusterToServicePrincipalIdName($clusterName)
{
    return $clusterName+$servicePrincipalIdPostFix
}

$servicePrincipalPasswordPostFix = "-principal-password"
function ClusterToServicePrincipalPasswordName($clusterName)
{
    return $clusterName+$servicePrincipalPasswordPostFix
}

function GetCertManagerDeploymentName()
{
    return "cert-manager"
}

function GetNginxDeploymentName($deploymentName)
{
    return PrependWithDash "nginx-ingress" $deploymentName
}

function GetNginxCertificateName()
{
    return "certificate"
}

function GetDevOpsOrganizationName()
{
    return "3Shape"
}

function GetDevOpsTeamName()
{
    return "Identity"
}
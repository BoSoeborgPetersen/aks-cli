param($prefix, $configPrefix, [switch] $addIp, $sku = "Basic", $ip, [switch] $oldDnsNamingConvention)

WriteAndSetUsage ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
    "[config prefix]" = "AKS-CLI config file name prefix"
    "[-add ip]" = "Flag to add Azure Public IP"
    "[sku]" = "Azure Public IP SKU"
    "[ip]" = "Azure Public IP to use"
})

$namespace = "ingress"
CheckCurrentCluster
$cluster = CurrentClusterName
$resourceGroup = CurrentClusterResourceGroup

$groupName = ($resourceGroup -replace '[0-9]+','') 
if ($oldDnsNamingConvention)
{
    $dns = PrependWithDash $prefix "$groupName-aks"
}
else 
{
    $dns = PrependWithDash $prefix "$groupName"
}
$publicIp = PublicIpName -prefix $prefix -cluster $cluster
$deployment = NginxDeploymentName $prefix
$configFile = PrependWithDash $configPrefix "nginx-config.yaml"

Write-Info "Installing Nginx"

if (AreYouSure)
{
    if ($addIp)
    {
        AzCommand "network public-ip create -g $resourceGroup -n $publicIp --allocation-method Static --sku $sku --idle-timeout 30"
    }
    if (!($ip))
    {
        $ip = AzQuery "network public-ip show -g $resourceGroup -n $publicIp" -q [ipAddress] -o tsv
    }
    KubectlCreateNamespace $namespace

    if ($prefix)
    {
        $extraParams = "--set controller.electionID='$prefix-ingress-controller-leader' --set controller.ingressClass='$prefix' --set controller.extraArgs.default-ssl-certificate=default/$prefix-certificate"
    }

    # LaterDo: Replace ' with ", and " with '
    HelmCommand "install '$deployment' ingress-nginx/ingress-nginx --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroup --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dns -f $PSScriptRoot/config/$configFile" -n $namespace
}
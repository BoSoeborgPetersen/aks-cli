# TODO: Change the naming-convention.ps1 to allow Communicate to use their own names somehow.
# TODO: add parameter to use different config file.
param($sku, $deployment, [switch] $addIp)

WriteAndSetUsage "aks nginx install [sku] [deployment name] [-add ip]"

$namespace = "ingress"
CheckCurrentCluster
$cluster = GetCurrentClusterName
$resourceGroup = GetCurrentClusterResourceGroup
SetDefaultIfEmpty ([ref]$sku) "Basic"

$dnsName = PrependWithDash $resourceGroup $deployment
$ipName = ClusterToIpAddressName $cluster $deployment
$nginxDeploymentName = GetNginxDeploymentName $deployment

if (AreYouSure)
{
    Write-Info "Install Nginx"

    if ($addIp)
    {
        AzCommand "network public-ip create -g $resourceGroup -n $ipName --allocation-method Static --sku $sku --idle-timeout 30"
    }
    $ip = AzQuery "network public-ip show -g $resourceGroup -n $ipName" -q [ipAddress] -o tsv
    KubectlCommand "create ns $namespace"

    if ($deployment)
    {
        $extraParams = "--set controller.electionID='$deployment-ingress-controller-leader' --set controller.ingressClass='$deployment' --set controller.extraArgs.default-ssl-certificate=default/$deployment-certificate"
    }

    # TODO: Replace ' with ", and " with '
    Helm3Command "install '$nginxDeploymentName' stable/nginx-ingress --namespace $namespace --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroup --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/nginx-config.yaml"
}
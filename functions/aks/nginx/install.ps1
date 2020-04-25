# TODO: Change the naming-convention.ps1 to allow Communicate to use their own names somehow.
# TODO: add parameter to use different config file.
param($sku, $deployment, $addIp)

WriteAndSetUsage "aks nginx install [sku] [deployment name]"

$namespace = "ingress"
CheckCurrentCluster
SetDefaultIfEmpty ([ref]$sku) "Basic"

$resourceGroupName = $GlobalCurrentCluster.ResourceGroup
$dnsName = PrependWithDash $resourceGroupName $deployment
$ipName = ClusterToIpAddressName $GlobalCurrentCluster.Name $deployment
$nginxDeploymentName = GetNginxDeploymentName $deployment

if (AreYouSure)
{
    Write-Info "Install Nginx"

    $ip = ExecuteQuery "az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString"
    ExecuteCommand "kubectl create ns $namespace $kubeDebugString"

    if ($deployment)
    {
        $extraParams = "--set controller.electionID='$deployment-ingress-controller-leader' --set controller.ingressClass='$deployment' --set controller.extraArgs.default-ssl-certificate=default/$deployment-certificate"
    }

    # TODO: Refactor into helper function in helm.ps1.
    ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com $debugString"
    ExecuteCommand "helm3 repo update $debugString"

    # TODO: Replace ' with ", and " with '
    ExecuteCommand "helm3 install '$nginxDeploymentName' stable/nginx-ingress --namespace $namespace --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/nginx-config.yaml $debugString"
}
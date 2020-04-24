# TODO: Change the naming-convention.ps1 to allow Communicate to use their own names somehow.
# TODO: add parameter to use different config file.
param($sku, $deploymentName, $addIp)

WriteAndSetUsage "aks nginx install [sku] [deployment name]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$sku) "Basic"

$resourceGroupName = $GlobalCurrentCluster.ResourceGroup
$dnsName = PrependWithDash $resourceGroupName $deploymentName
$ipName = ClusterToIpAddressName $GlobalCurrentCluster.Name $deploymentName
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

if (AreYouSure)
{
    Write-Info "Install Nginx-Ingress"

    $ip = ExecuteQuery "az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString"
    ExecuteCommand "kubectl create ns ingress $kubeDebugString"

    if ($deploymentName)
    {
        $extraParams = "--set controller.electionID='$deploymentName-ingress-controller-leader' --set controller.ingressClass='$deploymentName' --set controller.extraArgs.default-ssl-certificate=default/$deploymentName-certificate"
    }

    ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com $debugString"
    ExecuteCommand "helm3 repo update $debugString"

    # TODO: Replace ' with ", and " with '
    ExecuteCommand "helm3 install '$nginxDeploymentName' stable/nginx-ingress --namespace ingress --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/nginx-config.yaml $debugString"
}
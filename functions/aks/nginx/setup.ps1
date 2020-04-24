# TODO: Refactor to just create Public IP and then run "aks nginx install".
# TODO: Get rid of the this and add a flag to install.ps1 to add an ip.
param($sku, $deploymentName)

WriteAndSetUsage "aks nginx setup [sku] [deployment name]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$sku) "Basic"

$resourceGroupName = $GlobalCurrentCluster.ResourceGroup
$dnsName = PrependWithDash $GlobalCurrentCluster.Name $deploymentName
$ipName = ClusterToIpAddressName $GlobalCurrentCluster.Name $deploymentName
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

if (AreYouSure)
{
    Write-Info "Install Nginx-Ingress"

    # TODO: Try to remove -l and see if it still works, because of the resource group being specified.
    ExecuteCommand "az network public-ip create -g $resourceGroupName -n $ipName -l $($GlobalCurrentCluster.Location) --allocation-method Static --sku $sku --idle-timeout 30 $debugString"
    $ip = ExecuteQuery "az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString"
    ExecuteCommand "kubectl create ns ingress $kubeDebugString"

    if ($deploymentName)
    {
        $extraParams = "--set controller.electionID='$deploymentName-ingress-controller-leader' --set controller.ingressClass='$deploymentName' --set controller.extraArgs.default-ssl-certificate=default/$deploymentName-certificate"
    }

    ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com"
    ExecuteCommand "helm3 repo update"

    # TODO: Replace ' with ", and " with '
    ExecuteCommand "helm3 install '$nginxDeploymentName' stable/nginx-ingress --namespace ingress --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/nginx-config.yaml $debugString"
}
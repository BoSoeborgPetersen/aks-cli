param($sku, $deploymentName)

$usage = Write-Usage "aks nginx install [sku] [deployment name]"

VerifyCurrentCluster $usage

$resourceGroupName = $selectedCluster.ResourceGroup
$dnsName = PrependWithDash $resourceGroupName $deploymentName
$ipName = ClusterToIpAddressName $selectedCluster.Name $deploymentName
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

SetDefaultIfEmpty ([ref]$sku) "Basic"

Write-Info ("Install Nginx-Ingress")

$ip = ExecuteQuery ("az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString")
ExecuteCommand ("kubectl create ns ingress $kubeDebugString")

if ($deploymentName)
{
    $extraParams = "--set controller.electionID='$deploymentName-ingress-controller-leader' --set controller.ingressClass='$deploymentName' --set controller.extraArgs.default-ssl-certificate=default/$deploymentName-certificate"
}

ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com"
ExecuteCommand "helm3 repo update"

# TODO: Replace ' with ", and " with '
ExecuteCommand ("helm3 install '$nginxDeploymentName' stable/nginx-ingress --namespace ingress --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/identity-nginx-config.yaml $debugString")
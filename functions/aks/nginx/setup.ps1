# TODO: Refactor to just create Public IP and then run "aks nginx install".
param($sku, $deploymentName)

$usage = Write-Usage "aks nginx setup [sku] [deployment name]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$sku) "Basic"

$resourceGroupName = $selectedCluster.ResourceGroup
$dnsName = PrependWithDash $selectedCluster.Name $deploymentName
$ipName = ClusterToIpAddressName $selectedCluster.Name $deploymentName
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info ("Install Nginx-Ingress")

ExecuteCommand ("az network public-ip create -g $resourceGroupName -n $ipName -l $($selectedCluster.Location) --allocation-method Static --sku $sku --idle-timeout 30 $debugString")
$ip = ExecuteQuery ("az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString")
ExecuteCommand ("kubectl create ns ingress $kubeDebugString")

if ($deploymentName)
{
    $extraParams = "--set controller.electionID='$deploymentName-ingress-controller-leader' --set controller.ingressClass='$deploymentName' --set controller.extraArgs.default-ssl-certificate=default/$deploymentName-certificate"
}

ExecuteCommand "helm3 repo add stable https://kubernetes-charts.storage.googleapis.com"
ExecuteCommand "helm3 repo update"

# TODO: Replace ' with ", and " with '
ExecuteCommand ("helm3 install '$nginxDeploymentName' stable/nginx-ingress --namespace ingress --set controller.service.loadBalancerIP='$ip' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-dns-label-name`"=$dnsName -f $PSScriptRoot/config/nginx-config.yaml $debugString")
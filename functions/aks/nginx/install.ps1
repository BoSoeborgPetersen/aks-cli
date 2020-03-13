# TODO: Change this to "setup.ps1", and copy to install.ps1 with the IP creation replaced with an IP address.
param($sku, $deploymentName)

$usage = Write-Usage "aks nginx install [deployment name]"

VerifyCurrentCluster $usage

$resourceGroupName = $selectedCluster.ResourceGroup
$dnsName = PrependWithDash $selectedCluster.Name $deploymentName
$ipName = ClusterToIpAddressName $selectedCluster.Name $deploymentName
$nginxDeploymentName = GetNginxDeploymentName $deploymentName

SetDefaultIfEmpty ([ref]$sku) "Basic"

Write-Info ("Install Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az network public-ip create -g $resourceGroupName -n $ipName -l $($selectedCluster.Location) --allocation-method Static --dns-name $dnsName --sku $sku --idle-timeout 30 $debugString")
$ip = ExecuteQuery ("az network public-ip show -g $resourceGroupName -n $ipName --query '[ipAddress]' -o tsv $debugString")
ExecuteCommand ("kubectl create ns ingress $kubeDebugString")

if ($deploymentName)
{
    $extraParams = "--set controller.electionID='$deploymentName-ingress-controller-leader' --set controller.ingressClass='$deploymentName'"
}

# TODO: Replace ' with ", and " with '
ExecuteCommand ("helm install -n $nginxDeploymentName --namespace ingress stable/nginx-ingress --set controller.service.loadBalancerIP='$ip' --set controller.replicaCount=1 --set controller.service.externalTrafficPolicy='Local' $extraParams --set controller.service.annotations.`"service\.beta\.kubernetes\.io/azure-load-balancer-resource-group`"=$resourceGroupName -f $PSScriptRoot/config/nginx-config.yaml $debugString")
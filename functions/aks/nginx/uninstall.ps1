param($deploymentName)

$usage = Write-Usage "aks nginx uninstall [deployment name]"

VerifyCurrentCluster $usage

$nginxDeploymentName = GetNginxDeploymentName

if ($deploymentName)
{
    $nginxDeploymentName = "$deploymentName-$nginxDeploymentName"
}

Write-Info ("Uninstall Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm delete $nginxDeploymentName --purge $debugString"
ExecuteCommand "kubectl delete namespace ingress $kubeDebugString"

param($deploymentName)

$usage = Write-Usage "aks nginx logs [deployment name]"

VerifyCurrentCluster $usage

$nginxDeploymentName = GetNginxDeploymentName

if ($deploymentName)
{
    $nginxDeploymentName = "$deploymentName-$nginxDeploymentName"
}

Write-Info ("Get container logs for Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

$podName = ExecuteQuery "kubectl get po -l='release=$nginxDeploymentName' -o jsonpath='{.items[0].metadata.name}' -n ingress $kubeDebugString"
ExecuteCommand "kubectl logs -n ingress $podName $kubeDebugString"
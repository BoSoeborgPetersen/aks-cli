param($index, $deploymentName)

$usage = Write-Usage "aks nginx logs [pod index] [deployment name]"

VerifyCurrentCluster $usage

$deploymentName = GetdeploymentName

if ($deploymentName)
{
    $deploymentName = "$deploymentName-$deploymentName"
}

if($index)
{
    Write-Info "Show Nginx logs from pod (index: $index) in deployment '$deploymentName'"

    $podName = ExecuteQuery "kubectl get po -l='release=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' -n ingress $kubeDebugString"
    ExecuteCommand "kubectl logs -n ingress $podName $kubeDebugString"
}
else
{
    Write-Info ("Show Nginx-Ingress logs with Stern")

    ExecuteCommand "stern $deploymentName-controller -n ingress"
}
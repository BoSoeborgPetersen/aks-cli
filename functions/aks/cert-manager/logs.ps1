param($index)

$usage = Write-Usage "aks cert-manager logs"

VerifyCurrentCluster $usage

$deploymentName = GetCertManagerDeploymentName

if($index)
{
    Write-Info "Show Cert-Manager logs from pod (index: $index) in deployment '$deploymentName'"
    
    $podName = ExecuteQuery "kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' -n cert-manager $kubeDebugString"
    ExecuteCommand "kubectl logs $podName -n cert-manager $kubeDebugString"
}
else
{
    Write-Info "Show Cert-Manager logs with Stern"

    ExecuteCommand "stern $deploymentName -n cert-manager"
}
$usage = Write-Usage "aks cert-manager logs"

VerifyCurrentCluster $usage

$deploymentName = GetCertManagerDeploymentName

$podName = ExecuteQuery "kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[0].metadata.name}' $kubeDebugString"

Write-Info "Show pod '$podName' logs for the first pod in Cert-Manager deployment '$deploymentName'"

ExecuteCommand "kubectl logs $podName $kubeDebugString"
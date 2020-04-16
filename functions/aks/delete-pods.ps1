# TODO: Add "Are You Sure" question.
param($deploymentName)

$usage = Write-Usage "aks delete-pods [deployment]"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

$deployment = ExecuteQuery ("kubectl get deploy $deploymentName $kubeDebugString")

if (!$deployment)
{
    Write-Info "Deployment '$deploymentName' does not exist!"
    exit
}

$podNames = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[*].metadata.name}' $kubeDebugString")
    
Write-Info "Deleting pods in deployment '$deploymentName'"
exit # Temp: Until TODO.
ExecuteCommand ("kubectl delete pod $podNames $kubeDebugString")
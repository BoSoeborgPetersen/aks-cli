param($deploymentName)

$usage = Write-Usage "aks delete-pods <deployment>"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

$deployNameIfExist = ExecuteQuery ("kubectl get deploy $deploymentName $kubeDebugString")

if ($deployNameIfExist)
{
    $podNames = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[*].metadata.name}' $kubeDebugString")
    
    Write-Info "Deleting pods in deployment '$deploymentName'"
    
    ExecuteCommand ("kubectl delete pod $podNames $kubeDebugString")
}
else 
{
    Write-Info "Deployment '$deploymentName' does not exist!"
}
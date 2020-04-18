# Change to safely delete pods, by deleting 1 at a time and waiting for a new one to come up.
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

if (AreYouSure)
{
    Write-Info "Deleting pods in deployment '$deploymentName'"
    ExecuteCommand ("kubectl delete pod $podNames $kubeDebugString")
}
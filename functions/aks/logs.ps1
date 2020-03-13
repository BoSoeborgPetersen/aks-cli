# TODO: Change to menu with 3 subcommands
# - 'aks logs <pod-name>' -> 'aks logs pod <pod-name>' (take partial pod names)
# - 'aks logs deploy <deployment-name>' -> same
# - 'aks logs job <job-name>' -> same
param($deploymentName)

$usage = Write-Usage "aks logs <deployment/job name>"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

$deployNameIfExist = ExecuteQuery ("kubectl get deploy $deploymentName $kubeDebugString")

if ($deployNameIfExist)
{
    $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")
    
    Write-Info "Show pod '$podName' logs for the first pod in deployment '$deploymentName'"
    
    ExecuteCommand ("kubectl logs $podName $kubeDebugString")
}
else 
{
    $jobNameIfExist = ExecuteQuery ("kubectl get job $deploymentName $kubeDebugString")
    
    if ($jobNameIfExist)
    {
        $podName = ExecuteQuery ("kubectl get po -l='job-name=$deploymentName' -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for the first pod for job '$deploymentName'"
        
        ExecuteCommand ("kubectl logs $podName $kubeDebugString")
    }
    else 
    {
        Write-Info "Deployment '$deploymentName' does not exist!"
    }
}
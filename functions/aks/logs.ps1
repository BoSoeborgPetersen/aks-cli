# TODO: Change to menu with 3 subcommands
# - 'aks logs <pod-name>' -> 'aks logs pod <pod-name>' (take partial pod names)
# - 'aks logs deploy <deployment-name>' -> same
# - 'aks logs job <job-name>' -> same

# TODO: Check IndexOutOfRange.
# TODO: Use Stern.
param($deploymentName, $namespace, $index)

$usage = Write-Usage "aks logs <deployment/job name> [namespace] [pod index]"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

SetDefaultIfEmpty ([ref]$index) "0"

if ($namespace)
{
    $namespaceString = "-n $namespace"
}

$deployNameIfExist = ExecuteQuery ("kubectl get deploy $deploymentName $namespaceString $kubeDebugString")

if ($deployNameIfExist)
{
    $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
    
    Write-Info "Show pod '$podName' logs for pod number $index in deployment '$deploymentName'"
    
    ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
}
else 
{
    $jobNameIfExist = ExecuteQuery ("kubectl get job $deploymentName $namespaceString $kubeDebugString")
    
    if ($jobNameIfExist)
    {
        $podName = ExecuteQuery ("kubectl get po -l='job-name=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod number $index for job '$deploymentName'"
        
        ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else 
    {
        $daemonSetNameIfExist = ExecuteQuery ("kubectl get daemonset $deploymentName $namespaceString $kubeDebugString")
    
        if ($daemonSetNameIfExist)
        {
            $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
            
            Write-Info "Show pod '$podName' logs for pod number $index for daemonset '$deploymentName'"
            
            ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
        }
        else 
        {
            Write-Info "Deployment '$deploymentName' does not exist!"
        }
    }
}
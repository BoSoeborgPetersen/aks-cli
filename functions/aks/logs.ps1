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

if ($namespace)
{
    $namespaceString = "-n $namespace"
}

$deployNameIfExist = ExecuteQuery ("kubectl get deploy $deploymentName $namespaceString $kubeDebugString")

if ($deployNameIfExist)
{
    if ($index)
    {
        $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $index) in deployment '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

$jobNameIfExist = ExecuteQuery ("kubectl get job $deploymentName $namespaceString $kubeDebugString")

if ($jobNameIfExist)
{
    if ($index)
    {
        $podName = ExecuteQuery ("kubectl get po -l='job-name=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $index) for job '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

$daemonSetNameIfExist = ExecuteQuery ("kubectl get daemonset $deploymentName $namespaceString $kubeDebugString")

if ($daemonSetNameIfExist)
{
    if ($index)
    {
        $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$index].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $index) for daemonset '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

Write-Info "Deployment/Job/DaemonSet '$deploymentName' does not exist!"
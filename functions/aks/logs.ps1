# TODO: Change to menu with 4 subcommands
# - 'aks logs <pod-name>' -> 'aks logs pod <pod-name>' (take partial pod names)
# - 'aks logs deploy <deployment-name>' -> same
# - 'aks logs job <job-name>' -> same
# - 'aks logs daemonset <job-name>' -> same

# TODO: Check IndexOutOfRange.
param($deploymentName, $namespace, $podIndex)

$usage = Write-Usage "aks logs <deployment/job/daemonset name> [namespace] [pod index]"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

if ($namespace)
{
    $namespaceString = "-n $namespace"
}

$deployment = ExecuteQuery ("kubectl get deploy $deploymentName $namespaceString $kubeDebugString")

if ($deployment)
{
    if ($podIndex)
    {
        $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$podIndex].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $podIndex) in deployment '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

$job = ExecuteQuery ("kubectl get job $deploymentName $namespaceString $kubeDebugString")

if ($job)
{
    if ($podIndex)
    {
        $podName = ExecuteQuery ("kubectl get po -l='job-name=$deploymentName' -o jsonpath='{.items[$podIndex].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $podIndex) for job '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

$daemonset = ExecuteQuery ("kubectl get daemonset $deploymentName $namespaceString $kubeDebugString")

if ($daemonset)
{
    if ($podIndex)
    {
        $podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[$podIndex].metadata.name}' $namespaceString $kubeDebugString")
        
        Write-Info "Show pod '$podName' logs for pod (index: $podIndex) for daemonset '$deploymentName'"
        
        return ExecuteCommand ("kubectl logs $podName $namespaceString $kubeDebugString")
    }
    else
    {
        Write-Info ("Show $deploymentName logs with Stern")
    
        ExecuteCommand "stern $deploymentName $namespaceString"
    }
}

Write-Info "Deployment/Job/DaemonSet '$deploymentName' does not exist!"
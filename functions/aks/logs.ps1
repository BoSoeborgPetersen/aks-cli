param($regex, $namespace, $index)

WriteAndSetUsage "aks logs <regex> [namespace] [index]"

CheckCurrentCluster
CheckVariable $regex "regex"
$namespaceString = KubectlNamespaceString $namespace

if ($index)
{
    $pod = KubectlRegexMatch "pod" $regex $namespace $index

    Write-Info "Show pod '$pod' logs in namespace '$namespace'"
    
    return ExecuteCommand "kubectl logs $pod $namespaceString $kubeDebugString"
}
else
{
    Write-Info "Show '$regex' logs with Stern in namespace '$namespace'"

    ExecuteCommand "stern $regex $namespaceString"
}
param($regex, $namespace, $index)

WriteAndSetUsage "aks logs <regex> [namespace] [index]"

VerifyVariable $regex "regex"
VerifyCurrentCluster
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
param($regex, $namespace, $index)

$usage = Write-Usage "aks logs <regex> [namespace] [index]"

VerifyVariable $usage $regex "regex"
VerifyCurrentCluster $usage
$namespaceString = CreateNamespaceString $namespace

if ($index)
{
    $pod = KubectlRegexMatch $usage "pod" $regex $namespace $index

    Write-Info "Show pod '$pod' logs in namespace '$namespace'"
    
    return ExecuteCommand "kubectl logs $pod $namespaceString $kubeDebugString"
}
else
{
    Write-Info "Show '$regex' logs with Stern in namespace '$namespace'"

    ExecuteCommand "stern $regex $namespaceString"
}
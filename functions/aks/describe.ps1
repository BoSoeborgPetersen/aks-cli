param($type, $regex, $namespace, $index)

WriteAndSetUsage "aks describe <type> <regex> [namespace] [index]"

CheckCurrentCluster
CheckKubectlCommand "Describe"
CheckVariable $regex "regex"
$namespaceString = KubectlNamespaceString $namespace

Write-Info "Describe '$type' matching '$regex' with index '$index' in namespace '$namespace'"

$resource = KubectlRegexMatch $type $regex $namespace $index

ExecuteCommand "kubectl describe $type $resource $namespaceString $kubeDebugString"
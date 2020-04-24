param($type, $regex, $namespace, $index)

WriteAndSetUsage "aks describe <type> <regex> [namespace] [index]"

VerifyVariable $regex "regex"
VerifyCurrentCluster
ValidateKubectlCommand "Describe"
$namespaceString = KubectlNamespaceString $namespace
ValidateOptionalNumberRange ([ref]$index) "index" 1 100

Write-Info "Describe '$type' matching '$regex' with index '$index' in namespace '$namespace'"

$resource = KubectlRegexMatch $type $regex $namespace $index

ExecuteCommand "kubectl describe $type $resource $namespaceString $kubeDebugString"
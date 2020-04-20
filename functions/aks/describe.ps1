param($type, $regex, $namespace, $index)

$usage = Write-Usage "aks describe <type> <regex> [namespace] [index]"

VerifyVariable $usage $regex "regex"
VerifyCurrentCluster $usage
ValidateKubectlCommand "Describe"
$namespaceString = CreateNamespaceString $namespace
ValidateOptionalNumberRange $usage ([ref]$index) "index" 1 100

Write-Info "Describe '$type' matching '$regex' with index '$index' in namespace '$namespace'"

$resource = KubectlRegexMatch $usage $type $regex $namespace $index

ExecuteCommand "kubectl describe $type $resource $namespaceString $kubeDebugString"
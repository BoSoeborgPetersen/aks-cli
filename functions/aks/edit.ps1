param($type, $regex, $namespace, $index)

$usage = Write-Usage "aks edit <type> <regex> [namespace] [index]"

VerifyCurrentCluster $usage
ValidateKubectlCommand "Edit" -includeAll
VerifyVariable $usage $regex "regex"
$namespaceString = CreateNamespaceString $namespace

Write-Info "Edit '$type/$regex'[$index] in namespace '$namespace'"

ExecuteCommand "Set-Item -Path Env:KUBE_EDITOR -Value nano"

$resource = KubectlRegexMatch $usage $type $regex $namespace $index

ExecuteCommand "kubectl edit $type $resource $namespaceString $kubeDebugString"
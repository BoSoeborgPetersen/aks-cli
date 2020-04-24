param($type, $regex, $namespace, $index)

WriteAndSetUsage "aks edit <type> <regex> [namespace] [index]"

CheckCurrentCluster
CheckKubectlCommand "Edit" -includeAll
CheckVariable $regex "regex"
$namespaceString = KubectlNamespaceString $namespace

Write-Info "Edit '$type/$regex'[$index] in namespace '$namespace'"

ExecuteCommand "Set-Item -Path Env:KUBE_EDITOR -Value nano"

$resource = KubectlRegexMatch $type $regex $namespace $index

ExecuteCommand "kubectl edit $type $resource $namespaceString $kubeDebugString"
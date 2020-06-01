param($type, $regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks get <type> [regex] [namespace] [-a/-allNamespaces]"

CheckCurrentCluster
CheckKubectlCommand $type "Get" -includeAll
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Get '$type'" -r $regex -n $namespace

KubectlCommand "get $type" -r $regex -n $namespace
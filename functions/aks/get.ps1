param($type, $regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks get <type> [regex] [namespace] [-a/-allNamespaces]"

CheckCurrentCluster
CheckKubectlCommand $type "Get"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace $allNamespaces

Write-Info "Get '$type'" -r $regex -n $namespace

KubectlCommand "get $type" -r $regex -n $namespace
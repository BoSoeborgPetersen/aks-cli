param($type, $regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks top <type> [regex] [namespace] [-a/-allNamespaces]"

CheckCurrentCluster
CheckNoScriptSubCommand $type @{
    "no|node|nodes" = "Show Resource Utilization for Nodes."
    "po|pod|pods" = "Show Resource Utilization for Pods."
}
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace $allNamespaces

Write-Info "Show resource utilization of '$type'" -r $regex -n $namespace

KubectlCommand "top $type" -r $regex -n $namespace
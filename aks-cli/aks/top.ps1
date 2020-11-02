param($type, $regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "<type>" = "Kubernetes resource type (e.g. 'pod')"
    "<regex>" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
CheckNoScriptSubCommand $type @{
    "no|node|nodes" = "Show Resource Utilization for Nodes"
    "po|pod|pods" = "Show Resource Utilization for Pods"
}
$namespace = ConditionalOperator $allNamespaces "all" $namespace
$namespace = ConditionalOperator ($type -match "po|pod|pods") $namespace
KubectlCheckNamespace $namespace

Write-Info "Show resource utilization of '$type'" -r $regex -n $namespace

KubectlCommand "top $type" -r $regex -n $namespace
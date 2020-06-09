param($type, $regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks get" ([ordered]@{
    "<type>" = "Kubernetess resource type"
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
CheckKubectlCommand $type "Get" -includeAll
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Get '$type'" -r $regex -n $namespace

KubectlCommand "get $type" -r $regex -n $namespace
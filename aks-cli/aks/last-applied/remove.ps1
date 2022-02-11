param($regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Removing workload" -r $regex -n $namespace

$types = $('service','deployment','horizontalpodautoscaler','issuer','ingress')

Write-Info "Types: $types"

foreach($type in $types)
{
    Write-Info "Getting names of type '$type'" -r $regex -n $namespace

    $names = (KubectlQuery "get $type" -j "{$.items[?(@.metadata.name!='kubernetes')].metadata.name}" -r $regex -n $namespace -o json) -split ' '

    Write-Info "Names: $names"

    if (AreYouSure)
    {
        foreach($name in $names)
        {
            KubectlCommand "delete $type $name"
        }
    }
}
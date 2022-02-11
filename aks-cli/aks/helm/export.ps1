param($regex, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

Write-Info "Saving Helm releases" -r $regex -n $namespace

$names = HelmQuery "list -q" -r $regex -n $namespace

Write-Verbose "Names: $names"

foreach($name in $names)
{
    Write-Verbose "Name: $name"
    $version = HelmQuery "status $name -o json | jq .version"
    KubectlSaveHelmSecret $name $version $namespace
}
param($regex, $index = -1, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[index]" = "Index of the pod to open shell in"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckCurrentCluster
CheckVariable $regex "regex"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

if ($index -ne -1)
{
    $namespace, $name = KubectlGetRegex -t pod -r $regex -i $index -n $namespace

    Write-Info "Show pod '$name' logs" -r $regex -i $index -n $namespace

    KubectlCommand "logs $name" -n $namespace
}
else
{
    Write-Info "Show pod logs with Stern" -r $regex -n $namespace

    SternCommand $regex -n $namespace
}
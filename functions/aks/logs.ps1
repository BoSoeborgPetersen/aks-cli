param($regex, $index, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks logs <regex> [index] [namespace] [-a/-allNamespaces]"

CheckCurrentCluster
CheckVariable $regex "regex"
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace $allNamespaces

if ($index)
{
    $pod = KubectlGetRegex "pod" $regex $namespace $index

    Write-Info "Show pod '$pod' logs" -r $regex -i $index -n $namespace

    KubectlCommand "logs $pod" -n $namespace
}
else
{
    Write-Info "Show pod logs with Stern" -r $regex -n $namespace

    SternExecuteCommand $regex -n $namespace
}
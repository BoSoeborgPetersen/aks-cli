function SternExecuteCommand([string] $regex, [string] $namespace)
{
    $namespaceString = SternNamespaceString $namespace

    ExecuteCommand "stern $regex $namespaceString"
}

function SternNamespaceString($namespace)
{
    return ConditionalOperator ($namespace -eq "all") "--all-namespaces" (ConditionalOperator $namespace "-n $namespace" "")
}
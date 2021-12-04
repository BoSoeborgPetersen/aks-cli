function HelmNamespaceString($namespace)
{
    return ConditionalOperator $namespace " -n $namespace"
}

function HelmCommand($command, $namespace)
{
    $namespaceString = HelmNamespaceString $namespace

    ExecuteCommand ("helm $command" + $namespaceString + $debugString)
}

function HelmQuery($command, $namespace)
{
    $namespaceString = HelmNamespaceString $namespace

    return ExecuteQuery ("helm $command" + $namespaceString + $debugString)
}

function HelmCheck($chart, $namespace)
{
    $namespaceString = HelmNamespaceString $namespace

    $check = ExecuteQuery ("helm test $chart" + $namespaceString + " 2>null")

    if (!$check) 
    {
        Write-Error "Chart '$chart' does not exist" -n $namespace
    }
}

function HelmLatestChartVersion($chart)
{
    return HelmQuery "search repo $chart -o json | jq -r ' .[] | select(.name==\`"$chart\`") | .version' | % TrimStart v"
}

function HelmAddRepo($name, $url)
{
    HelmCommand "repo add $name $url"
    HelmCommand "repo update"
}
function HelmNamespaceString($namespace)
{
    return ConditionalOperator $namespace " -n $namespace"
}

function Helm2Command($command)
{
    ExecuteCommand ("helm2 $command" + $debugString)
}

function HelmCommand($command, $namespace)
{
    $namespaceString = HelmNamespaceString $namespace

    ExecuteCommand ("helm $command" + $namespaceString + $debugString)
}

function Helm2Query($command)
{
    return ExecuteQuery ("helm2 $command" + $debugString)
}

function HelmQuery($command)
{
    return ExecuteQuery ("helm $command" + $debugString)
}

function HelmCheck($chart, $namespace)
{
    $namespaceString = HelmNamespaceString $namespace

    $check = ExecuteQuery ("helm3 test $chart" + $namespaceString + " 2>null")

    if (!$check) 
    {
        Write-Error "Chart '$chart' does not exist" -n $namespace
    }
}

function HelmLatestChartVersion($chart)
{
    return HelmQuery "search repo $chart -o json | jq -r ' .[] | .version' | % TrimStart v"
}

function HelmAddRepo($name, $url)
{
    HelmCommand "repo add $name $url"
    HelmCommand "repo update"
}
function HelmCommand($command)
{
    ExecuteCommand "helm $command $debugString"
}

function Helm3Command($command)
{
    ExecuteCommand "helm3 $command $debugString"
}

function HelmQuery($command)
{
    return ExecuteQuery "helm $command $debugString"
}

function Helm3Query($command)
{
    return ExecuteQuery "helm3 $command $debugString"
}

function HelmLatestChartVersion($chart)
{
    return ((Helm3Query "search repo $chart -o json") | ConvertFrom-Json | Select-Object version | Format-Wide | Out-String).Replace('v', '').Trim()
}

function HelmAddRepo($name)
{
    Helm3Command "repo add stable $name"
    Helm3Command "repo update"
}
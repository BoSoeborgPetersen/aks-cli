param($regex, $index = 0, $namespace, [switch] $allNamespaces)

WriteAndSetUsage ([ordered]@{
    "<regex>" = "Expression to match against name"
    "[index]" = "Index of the pod to open shell in"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

CheckVariable $regex "regex"
CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

$namespace, $name = KubectlGetRegex -t pod -r $regex -i $index -n $namespace

function testCommand($command, $tryCommand)
{
    if (!$command)
    {
        $output = KubectlQuery "exec $name" -n $namespace -postFix "-- $tryCommand 2>&1"
        if (!($output -like "*command terminated with exit code 126*"))
        {
            $command = $tryCommand
        }
    }
    return $command
}

Write-Info "Show pod '$name' content size" -r $regex -n $namespace

$command = testCommand $command "du -h -s"
$command = testCommand $command "powershell -c `"'{0} MB' -f ((Get-ChildItem C:\app\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)`""

KubectlCommand "exec $name" -n $namespace -postFix "-- $command"
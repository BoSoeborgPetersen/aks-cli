param($regex, $namespace)

WriteAndSetUsage "aks pod size <regex> [namespace]"

CheckCurrentCluster
CheckVariable $regex "regex"

$pod = KubectlGetRegex "pod" $regex $namespace

function testCommand([ref] $command, $tryCommand)
{
    if (!$command.value)
    {
        $output = KubectlQuery "exec $pod" -n $namespace -postFix "-- $tryCommand 2>&1"
        if (!($output -like "*command terminated with exit code 126*"))
        {
            $command.value = $tryCommand
        }
    }
}

Write-Info "Show pod '$pod' content size" -r $regex $namespace

$command = ""
testCommand ([ref]$command) "du -h -s"
testCommand ([ref]$command) "powershell -c `"'{0} MB' -f ((Get-ChildItem C:\app\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)`""

KubectlCommand "exec $pod" -n $namespace -postFix "-- $command"
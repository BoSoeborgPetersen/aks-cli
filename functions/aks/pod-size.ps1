param($regex, $namespace)

$usage = Write-Usage "aks pod-size <regex> [namespace]"

VerifyVariable $usage $regex "regex"
VerifyCurrentCluster $usage
$namespaceString = CreateNamespaceString $namespace

$pod = KubectlRegexMatch $usage "pod" $regex $namespace

function testCommand([ref] $command, $tryCommand)
{
    if (!$command.value)
    {
        $output = ExecuteQuery "kubectl exec $pod $namespaceString -- $tryCommand 2>&1"
        if (!($output -like "*command terminated with exit code 126*"))
        {
            $command.value = $tryCommand
        }
    }
}

Write-Info "Show pod '$pod' content size"

$command = ""
testCommand ([ref]$command) "du -h -s"
testCommand ([ref]$command) "powershell -c `"'{0} MB' -f ((Get-ChildItem C:\app\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)`""

ExecuteCommand "kubectl exec $pod -- $command $kubeDebugString"
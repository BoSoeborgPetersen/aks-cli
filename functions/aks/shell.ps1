# TODO: Verify shell.
param($regex, $shell, $namespace, $index, [switch] $help = $false)

WriteAndSetUsage "aks shell <regex> [shell] [namespace] [index] [-help]"

VerifyVariable $regex "regex"
VerifyCurrentCluster
$namespaceString = KubectlNamespaceString $namespace
ValidateOptionalNumberRange ([ref]$index) "index" 1 100

$commands=@{
    "ash" = "Ash (Alpine)."
    "bash" = "Bash (Debian)."
    "cmd" = "Command Prompt (Windows)."
    "powershell" = "Powershell (Windows)."
}

# LaterDo: Generalize.
if ($help)
{
    ShowSubMenu $commands
    exit
}

function testShell([ref] $shell, $pod, $tryShell)
{
    if (!$shell.Value)
    {
        $output = ExecuteQuery "kubectl exec $pod $namespaceString -- $tryShell 2>&1"
        if (!$output -or ($output -like "*Microsoft Corporation*"))
        {
            $shell.Value = $tryShell
        }
    }
}

$pod = KubectlRegexMatch "pod" $regex $namespace $index

if (!$shell)
{
    testShell ([ref]$shell) $pod "bash"
    testShell ([ref]$shell) $pod "ash"
    testShell ([ref]$shell) $pod "powershell"
    testShell ([ref]$shell) $pod "cmd"
}

if (!$shell)
{
    ShowSubMenu $commands
    exit
}
    
Write-Info "Open shell '$shell' inside pod '$pod' in namespace '$namespace'"

# TODO: Test shell before actually opening it, and if it fails, then print an error message.
ExecuteCommand "kubectl exec -it $pod $namespaceString -- $shell $kubeDebugString"
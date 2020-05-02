param($regex, $shell, $index, $namespace, [switch] $help = $false)

WriteAndSetUsage "aks shell <regex> [shell] [index] [namespace] [-help]"

CheckVariable $regex "regex"
CheckCurrentCluster

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
        $output = KubectlCommand "exec $pod" -n $namespace -postFix "-- $tryShell 2>&1"
        if (!$output -or ($output -like "*Microsoft Corporation*"))
        {
            $shell.Value = $tryShell
        }
    }
}

$pod = KubectlGetRegex "pod" $regex $namespace $index

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

Write-Info "Open shell '$shell' inside pod '$pod'" -r $regex -i $index -n $namespace

testShell ([ref]$shell) $pod $shell

if ($shell)
{
    KubectlCommand "exec -it $pod" -n $namespace -postFix "-- $shell"
}
else 
{
    Write-Error "Could not open shell inside pod"
}
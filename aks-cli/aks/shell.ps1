param($regex, $shell, $index = 0, $namespace, [switch] $allNamespaces)

WriteAndSetUsage "aks shell" ([ordered]@{
    "[regex]" = "Expression to match against name"
    "[shell]" = "Shell type (ash, bash, cmd, powershell)"
    "[index]" = "Index of the pod to open shell in"
    "[namespace]" = KubernetesNamespaceDescription
    "[-allNamespaces]" = KubernetesAllNamespacesDescription
})

$commands=@{
    "ash" = "Ash (Alpine)"
    "bash" = "Bash (Debian)"
    "cmd" = "Command Prompt (Windows)"
    "powershell" = "Powershell (Windows)"
}

CheckVariable $regex "regex"
CheckCurrentCluster
$namespace = ConditionalOperator $allNamespaces "all" $namespace
KubectlCheckNamespace $namespace

function testShell($shell, $name, $tryShell)
{
    if (!$shell)
    {
        $output = KubectlCommand "exec $name" -n $namespace -postFix " -- $tryShell 2>&1"
        if (!$output -or ($output -like "*Microsoft Corporation*"))
        {
            $shell = $tryShell
        }
    }
    return $shell
}

$namespace, $name = KubectlGetRegex -t pod -r $regex -i $index -n $namespace

if (!$shell)
{
    $shell = testShell $shell $name "bash"
    $shell = testShell $shell $name "ash"
    $shell = testShell $shell $name "powershell"
    $shell = testShell $shell $name "cmd"
}

Write-Info "Open shell '$shell' inside pod '$name'" -r $regex -i $index -n $namespace

$shell = testShell $shell $name $shell

if (!$shell)
{
    Write-Error "Could not open shell inside pod"
    ShowSubMenu $commands
    exit
}

KubectlCommand "exec -it $name" -n $namespace -postFix " -- $shell"
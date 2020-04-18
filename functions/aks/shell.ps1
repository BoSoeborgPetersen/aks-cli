param($deploymentName, $shellType)

$usage = Write-Usage "aks shell [deployment name] [shell type]"

VerifyCurrentCluster $usage

$commands=@{
    "ash" = "Ash (Alpine)."
    "bash" = "Bash (Debian)."
    "cmd" = "Command Prompt (Windows)."
    "powershell" = "Powershell (Windows)."
}

function testShell([ref] $shellType, $podName, $type)
{
    if (!$shellType.value)
    {
        $output = ExecuteQuery "kubectl exec $podName -- $type 2>&1"
        if (!$output -or ($output -like "*Microsoft Corporation*"))
        {
            $shellType.value = $type
        }
    }
}

DeploymentChoiceMenu ([ref]$deploymentName)

# TODO: Rewrite to use "-help"
if ($deploymentName -eq "help")
{
    ShowSubMenu $commands
    exit
}

# TODO: Check that deployment exists.

$podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")

if (!$shellType)
{
    testShell ([ref]$shellType) $podName "ash"
    testShell ([ref]$shellType) $podName "bash"
    testShell ([ref]$shellType) $podName "cmd"
    testShell ([ref]$shellType) $podName "powershell"
}

if (!$shellType)
{
    ShowSubMenu $commands
    exit
}
    
Write-Info "Open shell '$shellType' inside pod '$podName' for the first pod in deployment '$deploymentName'"

# Test shell before actually opening it, and if it fails, then print an error message.

ExecuteCommand "kubectl exec -it $podName -- $shellType $kubeDebugString"
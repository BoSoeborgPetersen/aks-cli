param($deploymentName, $shellType)

$subCommands=@{
    "cmd" = "Command Prompt (Windows).";
    "powershell" = "Powershell (Windows).";
    "bash" = "Bash (Debian).";
    "ash" = "Ash (Alpine).";
}

function testShell([ref] $shellType, $podName, $type)
{
    if (!$shellType.value)
    {
        $output = ExecuteQuery "kubectl exec $podName $type 2>&1"
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
    ShowSubMenu $command $subCommands
    exit
}

$podName = ExecuteQuery ("kubectl get po -l='app=$deploymentName' -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")

if (!$shellType)
{
    testShell ([ref]$shellType) $podName "ash"
    testShell ([ref]$shellType) $podName "bash"
    testShell ([ref]$shellType) $podName "powershell"
    testShell ([ref]$shellType) $podName "cmd"
}
    
Write-Info "Open shell '$shellType' inside pod '$podName' for the first pod in deployment '$deploymentName'"

ExecuteCommand "kubectl exec -it $podName $shellType $kubeDebugString"
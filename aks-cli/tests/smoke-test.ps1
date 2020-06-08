# LaterDo: Finish
Write-Host "-- Running Tests --"

function TestCommand($command, $exitCommand)
{
    Write-Host "---|--- $command ---|---"
    Invoke-Expression $command

    if($exitCommand)
    {
        Invoke-Expression $exitCommand
    }
}

$azureLocation = "northeurope" # Maybe (constant): az get first location
$aksVersion = "1.16.7" # az get newest upgradable version.
$aksPreviewVersion = "1.17.3" # az get newest upgradable preview version.
$kubernetesDeployment = "status" # kubectl get first deploy.

$whatIf = $true

# TestCommand "aks" # Problem: How to not show output.
# TestCommand "aks autoscaler node add -whatif"
# TestCommand "aks autoscaler node disable -whatif"
# TestCommand "aks autoscaler node refresh -whatif"
# TestCommand "aks autoscaler pod add -whatif"
# TestCommand "aks autoscaler pod remove -whatif"
# TestCommand "aks autoscaler pod replace -whatif"
# TestCommand "aks cert-manager install -whatif"
# TestCommand "aks cert-manager logs -index 1"
# TestCommand "aks cert-manager purge -whatif"
# TestCommand "aks cert-manager uninstall -whatif"

TestCommand "aks current"
# TestCommand "aks delete -whatif" # Problem: How to skip prompt.
# TestCommand "aks describe po status" # Problem: Get deployment before.
# TestCommand "aks edit" # Problem: How to exit.
TestCommand "aks get po"
TestCommand "aks logs $kubernetesDeployment -index 1" # Problem: Hot to exit Stern (and how to hide output from Stern).
# TestCommand "aks shell $kubernetesDeployment" "exit" # Problem: How to exit.
# TestCommand "aks switch" # Problem: How to test!!!.
TestCommand "aks top no"
# TestCommand "aks upgrade -whatif" # Problem: How to skip prompt.
TestCommand "aks upgrades"
TestCommand "aks version"
TestCommand "aks versions"

# Write-Host "Error Count: $($error.count)"
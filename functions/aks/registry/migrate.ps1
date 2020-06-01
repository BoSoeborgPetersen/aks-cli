# LaterDo: Add a lot more checks.
# TODO: Allow to run from other subscriptions (add subscription parameter, calculate other variables from that).
param($oldRegistry, $oldRegistryRepo, $newRegistryRepo, $newRegistry)

WriteAndSetUsage "aks registry migrate <old registry> <old registry repo> <new registry repo> [new registry]"

CheckVariable $oldRegistry "old registry"
CheckVariable $oldRegistryRepo "old registry repo"
CheckVariable $newRegistryRepo "new registry repo"

if (!$newRegistry)
{
    $newRegistry = $oldRegistry
}

Write-Info "Migrate all docker images from registry/repo '$oldRegistry/$oldRegistryRepo' to registry/repo '$newRegistry/$newRegistryRepo'"

$imageTags = AzQuery "acr repository show-tags -n $oldRegistry --repository $oldRegistryRepo" | ConvertFrom-Json

foreach($imageTag in $imageTags.Split(" "))
{
    Write-Info "Moving '$oldRegistry.azurecr.io/${oldRegistryRepo}:$imageTag' to '$newRegistry.azurecr.io/${newRegistryRepo}:$imageTag'"
    AzCommand "acr import -n $newRegistry --source $oldRegistry.azurecr.io/${oldRegistryRepo}:$imageTag --image ${newRegistryRepo}:$imageTag"
    AzCommand "acr repository delete -n $oldRegistry --image ${oldRegistryRepo}:$imageTag -y"
}

AzCommand "acr repository delete -n $oldRegistry --repository $oldRegistryRepo"
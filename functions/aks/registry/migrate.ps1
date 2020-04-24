# TODO: Add a lot more checks.
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

$imageTags = ExecuteQuery "az acr repository show-tags -n $oldRegistry --repository $oldRegistryRepo $debugString" | ConvertFrom-Json

foreach($imageTag in $imageTags.Split(" "))
{
    Write-Info "Moving '$oldRegistry.azurecr.io/${oldRegistryRepo}:$imageTag' to '$newRegistry.azurecr.io/${newRegistryRepo}:$imageTag'"
    ExecuteCommand "az acr import -n $newRegistry --source $oldRegistry.azurecr.io/${oldRegistryRepo}:$imageTag --image ${newRegistryRepo}:$imageTag $debugString"
    ExecuteCommand "az acr repository delete -n $oldRegistry --image ${oldRegistryRepo}:$imageTag -y $debugString"
}

ExecuteCommand "az acr repository delete -n $oldRegistry --repository $oldRegistryRepo -y $debugString"
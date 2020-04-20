param($oldRegistryName, $oldRegistryRepoName, $newRegistryRepoName, $newRegistryName)

$usage = Write-Usage "aks registry migrate <old registry name> <old registry repo name> <new registry repo name> [new registry name]"

VerifyVariable $usage $oldRegistryName "old registry name"
VerifyVariable $usage $oldRegistryRepoName "old registry repo name"
VerifyVariable $usage $newRegistryRepoName "new registry repo name"

if (!$newRegistryName)
{
    $newRegistryName = $oldRegistryName
}

Write-Info "Migrate all docker images from registry/repo '$oldRegistryName/$oldRegistryRepoName' to registry/repo '$newRegistryName/$newRegistryRepoName'"

$imageTags = ExecuteQuery "az acr repository show-tags -n $oldRegistryName --repository $oldRegistryRepoName $debugString" | ConvertFrom-Json

foreach($imageTag in $imageTags.Split(" "))
{
    Write-Info "Moving '$oldRegistryName.azurecr.io/${oldRegistryRepoName}:$imageTag' to '$newRegistryName.azurecr.io/${newRegistryRepoName}:$imageTag'"
    ExecuteCommand "az acr import -n $newRegistryName --source $oldRegistryName.azurecr.io/${oldRegistryRepoName}:$imageTag --image ${newRegistryRepoName}:$imageTag $debugString"
    ExecuteCommand "az acr repository delete -n $oldRegistryName --image ${oldRegistryRepoName}:$imageTag -y $debugString"
}

ExecuteCommand "az acr repository delete -n $oldRegistryName --repository $oldRegistryRepoName -y $debugString"
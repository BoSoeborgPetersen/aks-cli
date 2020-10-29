param($name, [switch] $replaceDefaultKubernetesResources)

WriteAndSetUsage ([ordered]@{
    "<name>" = "Environment Name"
})

CheckVariable $name "environment name"

Write-Info "Replacing Environment"

if ($replaceDefaultKubernetesResources)
{
    AksCommand devops environment delete $name -addDefaultKubernetesResources
    AksCommand devops environment create $name -removeDefaultKubernetesResources
}
else 
{
    AksCommand devops environment delete $name
    AksCommand devops environment create $name
}
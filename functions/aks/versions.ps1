param($location)

WriteAndSetUsage "aks versions [location]"

CheckCurrentClusterOrVariable $location "[location]"

if ($location) 
{
    CheckLocationExists $location
    Write-Info "Available AKS versions for location '$location'"
}
else
{
    $location = $GlobalCurrentCluster.Location
    Write-Info "Available AKS versions for cluster location '$location'"
}

$input = ExecuteCommand "az aks get-versions -l $location --query orchestrators $debugString"
($input | ConvertFrom-Json | Select-Object @{ name='Version';expression= { "$($_.orchestratorVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
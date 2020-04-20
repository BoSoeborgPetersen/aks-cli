param($location)

$usage = Write-Usage "aks versions [location]"

VerifyCurrentClusterOrVariable $usage $location "[location]"

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

$input = ExecuteQuery "az aks get-versions -l $location --query orchestrators $debugString"
($input | ConvertFrom-Json | Select-Object @{ name='Version';expression= { "$($_.orchestratorVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
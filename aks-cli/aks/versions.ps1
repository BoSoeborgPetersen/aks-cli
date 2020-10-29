param($location)

WriteAndSetUsage ([ordered]@{
    "[location]" = (AzureLocationDescription "Current AKS cluster location")
})

CheckCurrentClusterOrVariable $location "[location]"

if ($location)
{
    AzCheckLocation $location
    Write-Info "Available AKS versions for location '$location'"
}
else
{
    $location = CurrentClusterLocation
    Write-Info "Available AKS versions for cluster location '$location'"
}

$versions = AzAksCommand "get-versions" -l $location -q orchestrators
($versions | ConvertFrom-Json | Sort-Object {[version] $_.orchestratorVersion} | Select-Object @{ name='Version';expression= { "$($_.orchestratorVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
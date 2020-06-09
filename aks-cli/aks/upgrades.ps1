WriteAndSetUsage "aks upgrades"

CheckCurrentCluster

Write-Info "Current AKS cluster upgradable versions"

$upgrades = AzAksCurrentCommand "get-upgrades" -q controlPlaneProfile.upgrades
($upgrades | ConvertFrom-Json | Sort-Object {[version] $_.kubernetesVersion} | Select-Object @{ name='Version';expression= { "$($_.kubernetesVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
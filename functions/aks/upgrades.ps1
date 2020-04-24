WriteAndSetUsage "aks upgrades"

VerifyCurrentCluster

Write-Info "Current AKS cluster upgradable versions"

$input = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query controlPlaneProfile.upgrades $debugString"
($input | ConvertFrom-Json | Sort-Object kubernetesVersion | Select-Object @{ name='Version';expression= { "$($_.kubernetesVersion) $($_.isPreview -replace 'True','(Preview)')" }} | Format-Table -HideTableHeaders | Out-String).Trim()
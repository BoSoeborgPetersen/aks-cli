Clear-Host
Write-Info "Choose Kubernetes Cluster: "

$global:GlobalCurrentCluster = ChooseAksCluster
az aks get-credentials -g $GlobalCurrentCluster.ResourceGroup -n $GlobalCurrentCluster.Name

$host.ui.RawUI.WindowTitle = $GlobalCurrentCluster.Name
function global:prompt
{
    Write-Host "AKS $(get-location)" -NoNewline
    Write-Host " [" -ForegroundColor Yellow -NoNewline
    Write-Host $global:GlobalCurrentCluster.Name -ForegroundColor Cyan -NoNewline
    Write-Host "]" -ForegroundColor Yellow -NoNewline
    Write-Host " >" -NoNewline
    return " "
}
# TODO: Always overwrite credentials
Clear-Host
Write-Info "Choose Kubernetes Cluster: "

$global:selectedCluster = ChooseAksCluster
az aks get-credentials -g $selectedCluster.ResourceGroup -n $selectedCluster.Name

$host.ui.RawUI.WindowTitle = $selectedCluster.Name
function global:prompt
{
    Write-Host ("AKS $(get-location)") -NoNewline
    Write-Host (" [") -ForegroundColor Yellow -NoNewline
    Write-Host ($global:selectedCluster.Name) -ForegroundColor Cyan -NoNewline
    Write-Host ("]") -ForegroundColor Yellow -NoNewline
    Write-Host (" >") -NoNewline
    return " "
}
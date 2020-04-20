Clear-Host
Write-Info "Choose Azure Subscription: "

$global:GlobalCurrentSubscription = ChooseAzureSubscription
az account set -s $GlobalCurrentSubscription.name

ExecuteCommand "aks switch cluster"
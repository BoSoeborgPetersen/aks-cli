Clear-Host
Write-Info "Choose Azure Subscription: "

$global:selectedAccount = ChooseAzureAccount
az account set -s $selectedAccount.name

ExecuteCommand "aks switch cluster"
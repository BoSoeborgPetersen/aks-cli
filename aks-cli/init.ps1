Clear-Host
az login --use-device-code -o none

Set-Alias aks "$PSScriptRoot/aks.ps1" -Scope Global

aks switch

aks
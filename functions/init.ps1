Clear-Host
az login

New-Alias aks "$PSScriptRoot\aks.ps1" -Scope Global
function global:.. { Set-Location .. }
function global:... { Set-Location ../.. }
function global:.... { Set-Location ../../.. }
Register-BashArgumentCompleter az /etc/bash_completion.d/azure-cli -Verbose
Register-BashArgumentCompleter kubectl /usr/share/bash-completion/completions/kubectl_completions.sh -Verbose
Register-BashArgumentCompleter helm /usr/share/bash-completion/completions/helm_completions.sh -Verbose

aks switch

Clear-Host
aks
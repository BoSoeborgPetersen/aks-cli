Clear-Host
az login -o none

New-Alias aks "$PSScriptRoot/aks.ps1" -Scope Global
New-Alias test "$PSScriptRoot/test.ps1" -Scope Global
New-Alias a aks -Scope Global
New-Alias k kubectl -Scope Global

function global:.. { Set-Location .. }
function global:... { Set-Location ../.. }
function global:.... { Set-Location ../../.. }

Register-BashArgumentCompleter az ~/.bashrc
Register-BashArgumentCompleter kubectl /usr/share/bash-completion/completions/kubectl.bash
Register-BashArgumentCompleter k /usr/share/bash-completion/completions/kubectl.bash
Register-BashArgumentCompleter stern /usr/share/bash-completion/completions/stern.bash
Register-BashArgumentCompleter helm2 /usr/share/bash-completion/completions/helm2.bash
Register-BashArgumentCompleter helm /usr/share/bash-completion/completions/helm.bash

Set-Item -Path Env:KUBE_EDITOR -Value nano
Set-Item -Path Env:HELM_EXPERIMENTAL_OCI -Value 1

aks switch

Clear-Host
aks
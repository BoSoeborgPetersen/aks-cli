# Move word functionality
Set-PSReadLineKeyHandler -Chord Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord

# Oh My Posh
oh-my-posh --init --shell pwsh --config ~/.config/powershell/aks-cli.omp.json | Invoke-Expression
Import-Module -Name Terminal-Icons

# Aliases
Set-Alias a aks -Scope Global
Set-Alias k kubectl -Scope Global
Set-Alias ctx kubectx -Scope Global
Set-Alias ns kubens -Scope Global
Set-Alias h helm -Scope Global

# Alias functions
function global:kg { kubectl get $args }
function global:ktopco { kg po | grep actor | awk '{print $1}' | k top po --containers }
function global:k-top-co { kg po | grep actor | awk '{print $1}' | k top po --containers }

# Helper functions
function global:.. { Set-Location .. }
function global:... { Set-Location ../.. }
function global:.... { Set-Location ../../.. }

# Setup autocomplete
Register-BashArgumentCompleter az ~/.bashrc
Register-BashArgumentCompleter kubectl /usr/share/bash-completion/completions/kubectl.bash
Register-BashArgumentCompleter k /usr/share/bash-completion/completions/kubectl.bash
Register-BashArgumentCompleter stern /usr/share/bash-completion/completions/stern.bash
Register-BashArgumentCompleter kubens /usr/share/bash-completion/completions/kubens.bash
Register-BashArgumentCompleter ctx /usr/share/bash-completion/completions/kubectx.bash
Register-BashArgumentCompleter ns /usr/share/bash-completion/completions/kubens.bash
Register-BashArgumentCompleter helm /usr/share/bash-completion/completions/helm.bash
Register-BashArgumentCompleter h /usr/share/bash-completion/completions/helm.bash

# Change environmental variables for configuration
Set-Item -Path Env:KUBE_EDITOR -Value nano
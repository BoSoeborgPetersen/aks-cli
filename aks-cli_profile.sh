#!/bin/bash

# Oh My Posh
eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/aks-cli.omp.json)"
# Import-Module -Name Terminal-Icons

# Aliases
alias a='aks'
alias k='kubectl'
alias ctx='kubectx'
alias ns='kubens'
alias h='helm'

# # Alias functions
alias kg="kubectl get"
alias ktopco="kg po | grep actor | awk '{print $1}' | k top po --containers"
alias k-top-co="kg po | grep actor | awk '{print $1}' | k top po --containers"

# Helper functions
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Setup autocomplete

$COMPLETIONS=/usr/share/bash-completion/completions
cp $COMPLETIONS/kubectl.bash $COMPLETIONS/k.bash
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Change environmental variables for configuration
export KUBE_EDITOR="/usr/bin/nano"
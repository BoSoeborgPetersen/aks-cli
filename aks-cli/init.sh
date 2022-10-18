#!/bin/bash

printf "\033c"
az login --use-device-code -o none
# TODO: Replace with function that switches back to PWD, check powershell profile for example in pwsh.
alias aks='cd /app/new-dev-aks-cli;go run main.go'
aks switch
aks
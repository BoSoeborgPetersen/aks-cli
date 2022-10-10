#!/bin/bash

printf "\033c"
az login --use-device-code -o none
alias aks='cd /app/new-dev-aks-cli;go run main.go'
aks switch
aks
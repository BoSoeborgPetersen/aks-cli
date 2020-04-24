param($environmentName)

WriteAndSetUsage "aks devops environment replace-all <environment name> <cluster name>"

CheckVariable $environmentName "environment name"

aks devops environment delete-all $environmentName
aks devops environment create-all $environmentName
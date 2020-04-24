param($environmentName)

WriteAndSetUsage "aks devops environment replace-all <environment name> <cluster name>"

VerifyVariable $environmentName "environment name"

aks devops environment delete-all $environmentName
aks devops environment create-all $environmentName
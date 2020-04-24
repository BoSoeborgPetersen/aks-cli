param($environmentName)

WriteAndSetUsage "aks devops environment replace <environment name>"

VerifyVariable $environmentName "environment name"

aks devops environment delete $environmentName
aks devops environment create $environmentName
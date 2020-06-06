param($environmentName)

WriteAndSetUsage "aks devops environment replace <environment name>"

CheckVariable $environmentName "environment name"

aks devops environment delete $environmentName
aks devops environment create $environmentName
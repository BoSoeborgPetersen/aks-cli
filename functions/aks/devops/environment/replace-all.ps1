param($environmentName)

$usage = Write-Usage "aks devops environment replace-all <environment name> <cluster name>"

VerifyVariable $usage $environmentName "environment name"

aks devops environment delete-all $environmentName
aks devops environment create-all $environmentName
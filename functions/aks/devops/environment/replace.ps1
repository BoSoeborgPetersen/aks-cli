param($environmentName)

$usage = Write-Usage "aks devops environment replace <environment name>"

VerifyVariable $usage $environmentName "environment name"

aks devops environment delete $environmentName
aks devops environment create $environmentName
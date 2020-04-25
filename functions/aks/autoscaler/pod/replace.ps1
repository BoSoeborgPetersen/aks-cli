param($deployment, $min, $max, $limit, $namespace)

WriteAndSetUsage "aks autoscaler pod replace [deployment] [min] [max] [limit] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 1 -max 1000 -default 3
CheckNumberRange ([ref]$max) "max" -min 1 -max 1000 -default 6
CheckNumberRange ([ref]$limit) "limit" -min 40 -max 80 -default 50
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace

Write-Info "Replace pod autoscaler for deployment '$deployment'"

ExecuteCommand "aks autoscaler pod remove $deployment $namespace"
ExecuteCommand "aks autoscaler pod add $deployment $min $max $limit $namespace"
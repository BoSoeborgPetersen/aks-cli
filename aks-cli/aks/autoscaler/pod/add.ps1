param($deployment, $min, $max, $limit, $namespace)

WriteAndSetUsage "aks autoscaler pod add [deployment] [min] [max] [limit] [namespace]"

CheckCurrentCluster
CheckNumberRange ([ref]$min) "min" -min 1 -max 1000 -default 3
CheckNumberRange ([ref]$max) "max" -min 1 -max 1000 -default 30
CheckNumberRange ([ref]$limit) "limit" -min 40 -max 80 -default 60
KubectlCheckDeployment ([ref]$deployment) $namespace -showMenu

Write-Info "Add pod autoscaler (min: $min, max: $max, cpu limit: $limit) to deployment '$deployment' in namespace '$namespace'"

KubectlCommand "autoscale deploy $deployment --cpu-percent=$limit --min=$min --max=$max" -n $namespace
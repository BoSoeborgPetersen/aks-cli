param($cpuLimit, $minPodCount, $maxPodCount, $deploymentName)

$usage = Write-Usage "aks pod-autoscaler add [cpu limit] [min pod count] [max pod count] [deployment name] [namespace]"

VerifyCurrentCluster $usage
SetDefaultIfEmpty ([ref]$cpuLimit) 50
SetDefaultIfEmpty ([ref]$minPodCount) 3 
SetDefaultIfEmpty ([ref]$maxPodCount) 6
DeploymentChoiceMenu ([ref]$deploymentName)
$namespaceString = CreateNamespaceString $namespace

ValidateNumberRange $usage ([ref]$cpuLimit) "cpu limit" 40 80
ValidateNumberRange $usage ([ref]$minPodCount) "min pod count" 1 1000
ValidateNumberRange $usage ([ref]$maxPodCount) "max pod count" 1 1000
VerifyDeployment $deploymentName $namespace

Write-Info "Add pod autoscaler (cpu limit: $cpuLimit, min count: $minPodCount, max count: $maxPodCount) to deployment '$deploymentName' in namespace '$namespace'"

ExecuteCommand "kubectl autoscale deploy $deploymentName --cpu-percent=$cpuLimit --min=$minPodCount --max=$maxPodCount $namespaceString $kubeDebugString"
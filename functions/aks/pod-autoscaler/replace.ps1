param($cpuLimit, $minPodCount, $maxPodCount, $deploymentName)

WriteAndSetUsage "aks pod-autoscaler replace [cpu limit] [min pod count] [max pod count] [deployment name]"

VerifyCurrentCluster
SetDefaultIfEmpty ([ref]$cpuLimit) 50
SetDefaultIfEmpty ([ref]$minPodCount) 3 
SetDefaultIfEmpty ([ref]$maxPodCount) 6
DeploymentChoiceMenu ([ref]$deploymentName)

ValidateNumberRange ([ref]$cpuLimit) "cpu limit" 40 80
ValidateNumberRange ([ref]$minPodCount) "min pod count" 1 1000
ValidateNumberRange ([ref]$maxPodCount) "max pod count" 1 1000
KubectlVerifyDeployment $deploymentName $namespace

Write-Info "Replace pod autoscaler for deployment '$deploymentName'"

ExecuteCommand "aks pod-autoscaler remove $deploymentName $debugString"
ExecuteCommand "aks pod-autoscaler add $cpuLimit $minPodCount $maxPodCount $deploymentName $debugString"
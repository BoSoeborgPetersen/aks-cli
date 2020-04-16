param($podCount, $deploymentName)

$usage = Write-Usage "aks scale-pods <pod count> [deployment name]"

VerifyCurrentCluster $usage
ValidateNumberRange $usage ([ref]$podCount) "pod count" 0 1000
DeploymentChoiceMenu ([ref]$deploymentName)

Write-Info "Scaling number of pods to '$podCount', for deployment '$deploymentName'"

ExecuteCommand "kubectl scale --replicas $podCount deploy/$deploymentName $kubeDebugString"
param($podCount, $deploymentName)

$usage = Write-Usage "aks scale-pods <pod count> <deployment name>"

DeploymentChoiceMenu ([ref]$deploymentName)

ValidateNumberRange $usage ([ref]$podCount) "pod count" 0 1000

Write-Info "Scaling number of pods to '$podCount', for deployment '$deploymentName'"

ExecuteCommand "kubectl scale --replicas $podCount deploy/$deploymentName $kubeDebugString"
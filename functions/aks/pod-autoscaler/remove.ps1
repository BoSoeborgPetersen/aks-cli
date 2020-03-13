param($deploymentName)

$usage = Write-Usage "aks pod-autoscaler remove <deployment name>"

DeploymentChoiceMenu ([ref]$deploymentName)

VerifyVariable $usage $deploymentName "deployment name"

Write-Info "Remove pod autoscaler for deployment '$deploymentName'"

ExecuteCommand "kubectl delete hpa $deploymentName $kubeDebugString"

  
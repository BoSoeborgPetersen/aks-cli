param($cpuLimit, $minPodCount, $maxPodCount, $deploymentName)

$usage = Write-Usage "aks pod-autoscaler replace [cpu limit] [min node count] [max node count] [deployment name]"

VerifyCurrentCluster $usage

VerifyVariable $usage $cpuLimit "cpu limit"
VerifyVariable $usage $minPodCount "min pod count"
VerifyVariable $usage $maxPodCount "max pod count"
VerifyVariable $usage $deploymentName "deployment name"

Write-Info "Replace pod autoscaler for deployment '$deploymentName'"

ExecuteCommand "aks node-autoscaler add $cpuLimit $minPodCount $maxPodCount $deploymentName $debugString"
ExecuteCommand "aks node-autoscaler remove $deploymentName $debugString"
param($deploymentName, $namespace)

$usage = Write-Usage "aks pod-autoscaler remove [deployment name] [namespace]"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)
$namespaceString = CreateNamespaceString $namespace

VerifyDeployment $deploymentName $namespace

Write-Info "Remove pod autoscaler for deployment '$deploymentName' in namespace '$namespace'"

ExecuteCommand "kubectl delete hpa $deploymentName $namespaceString $kubeDebugString"

  
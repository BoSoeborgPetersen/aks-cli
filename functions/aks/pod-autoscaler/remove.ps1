param($deploymentName, $namespace)

WriteAndSetUsage "aks pod-autoscaler remove [deployment name] [namespace]"

VerifyCurrentCluster
DeploymentChoiceMenu ([ref]$deploymentName)
$namespaceString = KubectlNamespaceString $namespace

KubectlVerifyDeployment $deploymentName $namespace

Write-Info "Remove pod autoscaler for deployment '$deploymentName' in namespace '$namespace'"

ExecuteCommand "kubectl delete hpa $deploymentName $namespaceString $kubeDebugString"

  
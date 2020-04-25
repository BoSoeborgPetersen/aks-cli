param($deployment, $namespace)

WriteAndSetUsage "aks autoscaler pod remove [deployment] [namespace]"

CheckCurrentCluster
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace
$namespaceString = KubectlNamespaceString $namespace

Write-Info "Remove pod autoscaler for deployment '$deployment' in namespace '$namespace'"

ExecuteCommand "kubectl delete hpa $deployment $namespaceString $kubeDebugString"

  
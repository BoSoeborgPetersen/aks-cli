param($deployment, $namespace)

WriteAndSetUsage "aks autoscaler pod remove [deployment] [namespace]"

CheckCurrentCluster
KubectlCheckDeployment ([ref]$deployment) $namespace -showMenu

Write-Info "Remove pod autoscaler for deployment '$deployment' in namespace '$namespace'"

KubectlCommand "delete hpa $deployment" -n $namespace
WriteAndSetUsage "aks pod-clean"

CheckCurrentCluster

Write-Info "Deleting all failed pods in all namespaces"

if (AreYouSure)
{
    ExecuteCommand "kubectl delete pod -A --field-selector 'status.phase=Failed' $kubeDebugString"
}


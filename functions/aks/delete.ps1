# TODO: Add "Are You Sure" question.
$usage = Write-Usage "aks delete"

VerifyCurrentCluster $usage

Write-Info ("Deleting current AKS cluster")
exit # Temp: Until TODO.
ExecuteCommand ("az aks delete -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) $debugString")
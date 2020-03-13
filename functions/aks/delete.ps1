$usage = Write-Usage "aks delete"

VerifyCurrentCluster $usage

Write-Info ("Deleting current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("az aks delete -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) $debugString")
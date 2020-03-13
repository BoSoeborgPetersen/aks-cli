$usage = Write-Usage "aks version"

VerifyCurrentCluster $usage

Write-Info ("Current AKS cluster '$($selectedCluster.Name)' version")

ExecuteQuery ("az aks show -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --query 'kubernetesVersion' -o tsv $debugString")
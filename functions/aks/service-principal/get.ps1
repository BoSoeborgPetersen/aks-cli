$usage = Write-Usage "aks service-principal get"

Write-Info ("Get AKS cluster '$($selectedCluster.Name)' service principal")

ExecuteCommand ("az aks show -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --query servicePrincipalProfile.clientId -o tsv $debugString")
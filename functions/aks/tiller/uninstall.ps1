$usage = Write-Usage "aks tiller uninstall"

VerifyCurrentCluster $usage

Write-Info ("Uninstalling Tiller (Helm server-side) from current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand ("kubectl delete deployment tiller-deploy -n kube-system $kubeDebugString")
ExecuteCommand ("kubectl delete clusterrolebinding tiller $kubeDebugString")
ExecuteCommand ("kubectl delete serviceaccount tiller -n kube-system $kubeDebugString")
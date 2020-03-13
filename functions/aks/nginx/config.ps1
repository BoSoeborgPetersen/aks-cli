param($deploymentName)

$usage = Write-Usage "aks nginx config [deployment name]"

VerifyCurrentCluster $usage

$nginxDeploymentName = GetNginxDeploymentName $deploymentName

Write-Info ("Print config file for Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

$podName = ExecuteQuery ("kubectl get po -l='release=$nginxDeploymentName' -o jsonpath='{.items[0].metadata.name}' -n ingress $kubeDebugString")
ExecuteCommand ("kubectl exec -n ingress $podName cat /etc/nginx/nginx.conf $kubeDebugString")
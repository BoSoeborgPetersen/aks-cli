$usage = Write-Usage "aks configure-dns"

VerifyCurrentCluster $usage

Write-Info ("For each service in current AKS cluster '$($selectedCluster.Name)', the associated Azure public IP gets it dns prefix set to the name of the service")

$kubernetesServices = ExecuteQuery "kubectl get svc -o jsonpath='{..metadata.name}'"
foreach($svc in $kubernetesServices.Split(" "))
{
    if($svc -ne "kubernetes")
    {
        $ip = ExecuteQuery ("kubectl get svc $svc -o jsonpath='{..status.loadBalancer.ingress..ip}' $kubeDebugString")
        $id = ExecuteQuery ("az network public-ip list --query `"[?ipAddress!=null]|[?contains(ipAddress, '$ip')].[id]`" -o tsv $debugString")

        ExecuteCommand ("az network public-ip update --ids $id --dns-name $svc $debugString")
        Write-Host ("Changed Azure public ip resource ('ID: $id', IP: '$ip') to have DNS prefix '$svc', equal to the name of the corresponding Kubernetes service")
    }
}
param($index)

WriteAndSetUsage "aks cert-manager logs [index]"

CheckCurrentCluster

$deployment = GetCertManagerDeploymentName

if($index)
{
    Write-Info "Show Cert-Manager logs from pod (index: $index) in deployment '$deployment'"
    
    $pod = KubectlGetPod $deployment "cert-manager" $index
    KubectlCommand "logs $pod -n cert-manager"
}
else
{
    Write-Info "Show Cert-Manager logs with Stern"

    ExecuteCommand "stern $deployment -n cert-manager"
}
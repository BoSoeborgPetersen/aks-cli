param($index)

$usage = Write-Usage "aks cert-manager logs [index]"

VerifyCurrentCluster $usage

$deployment = GetCertManagerDeploymentName

if($index)
{
    Write-Info "Show Cert-Manager logs from pod (index: $index) in deployment '$deployment'"
    
    $pod = KubectlGetPod $usage $deployment "cert-manager" $index
    ExecuteCommand "kubectl logs $pod -n cert-manager $kubeDebugString"
}
else
{
    Write-Info "Show Cert-Manager logs with Stern"

    ExecuteCommand "stern $deployment -n cert-manager"
}
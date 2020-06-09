param($index = -1)

WriteAndSetUsage "aks cert-manager logs" ([ordered]@{
    "[index]" = "Index of the pod to show logs from"
})

CheckCurrentCluster
$deployment = CertManagerDeploymentName

if ($index -ne -1)
{
    Write-Info "Show Cert-Manager logs from pod (index: $index) in deployment '$deployment'"
    
    $pod = KubectlGetPod $deployment -n "cert-manager" -i $index
    KubectlCommand "logs $pod" -n cert-manager
}
else
{
    Write-Info "Show Cert-Manager logs with Stern"

    SternCommand $deployment -n cert-manager
}
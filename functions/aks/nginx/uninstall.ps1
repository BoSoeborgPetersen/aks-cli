param($deployment, [switch] $purge)

WriteAndSetUsage "aks nginx uninstall [deployment name] [-purge]"

$namespace = "ingress"
CheckCurrentCluster
$nginxDeployment = GetNginxDeploymentName $deployment

Write-Info "Uninstall Nginx"

Helm3Command "uninstall $nginxDeployment -n $namespace"

if ($purge)
{
    Write-Info "Remove Nginx namespace"
    
    if (AreYouSure)
    {
        KubectlCommand "delete ns $namespace"
    }
}
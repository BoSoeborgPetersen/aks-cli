param($deploymentName)

$usage = Write-Usage "aks nginx upgrade [deployment name]"

VerifyCurrentCluster $usage

$nginxDeploymentName = GetNginxDeploymentName

if ($deploymentName)
{
    $nginxDeploymentName = "$deploymentName-$nginxDeploymentName"
}

Write-Info ("Upgrade Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

ExecuteCommand "helm upgrade --reuse-values $nginxDeploymentName stable/nginx-ingress $debugString"
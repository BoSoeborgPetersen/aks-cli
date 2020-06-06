param($deployment, $namespace)

WriteAndSetUsage "aks pod delete [deployment] [namespace]"

CheckCurrentCluster
KubectlCheckDeployment ([ref]$deployment) $namespace -showMenu

$pods = KubectlGetPods $deployment $namespace

Write-Info "Safely deleting pods for deployment '$deployment' in namespace '$namespace':"
$pods | Format-List

if (AreYouSure)
{
    foreach ($pod in $pods)
    {
        KubectlCommand "delete pod $pod" -n $namespace
        KubectlCommand "rollout status deploy/$deployment" -n $namespace
    }
}
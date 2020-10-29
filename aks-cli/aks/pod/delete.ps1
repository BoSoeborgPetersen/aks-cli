param($deployment, $namespace)

WriteAndSetUsage ([ordered]@{
    "[deployment]" = "Kubernetes deployment"
    "[namespace]" = KubernetesNamespaceDescription
})

CheckCurrentCluster
$deployment = KubectlCheckDeployment $deployment $namespace
KubectlCheckNamespace $namespace

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
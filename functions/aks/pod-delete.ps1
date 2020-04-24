param($deployment, $namespace)

WriteAndSetUsage "aks pod-delete [deployment] [namespace]"

CheckCurrentCluster
DeploymentChoiceMenu ([ref]$deployment) $namespace
KubectlCheckDeployment $deployment $namespace
$namespaceString = KubectlNamespaceString $namespace

$pods = KubectlGetPods $deployment $namespace

Write-Info "Safely deleting pods for deployment '$deployment' in namespace '$namespace':"
$pods.Split(' ') | Format-List

if (AreYouSure)
{
    foreach ($pod in ($pods.Split(' ')))
    {
        ExecuteCommand "kubectl delete pod $pod $namespaceString $kubeDebugString"
        ExecuteCommand "kubectl rollout status deploy/$deployment $namespaceString $kubeDebugString"
    }
}
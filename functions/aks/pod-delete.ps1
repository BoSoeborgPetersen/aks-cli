param($deployment, $namespace)

WriteAndSetUsage "aks pod-delete [deployment] [namespace]"

VerifyCurrentCluster
DeploymentChoiceMenu ([ref]$deployment)
$namespaceString = KubectlNamespaceString $namespace

KubectlVerifyDeployment $deployment $namespace

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
param($deployment, $namespace)

$usage = Write-Usage "aks pod-delete [deployment] [namespace]"

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deployment)
$namespaceString = CreateNamespaceString $namespace

VerifyDeployment $deployment $namespace

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
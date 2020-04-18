param($resourceType, $deploymentName)

$usage = Write-Usage "aks top <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "no" = "Show Nodes."
    "po" = "Show Pods."
}

if ($deploymentName) {
    Write-Info ("Show resource utilization of Kubernetes resources of type '$resourceType' for deployment '$deploymentName' in current AKS cluster '$($selectedCluster.Name)'")
}
else {
    Write-Info ("Show resource utilization of all Kubernetes resources of type '$resourceType' in current AKS cluster '$($selectedCluster.Name)'")
}

if ($deploymentName){
    Switch -Wildcard ($resourceType) {
        'no*' { 
            $selectorString = ""
        }
        'po*' { 
            $selectorString = "-l='app=$deploymentName'"
        }
    }
}

ExecuteCommand "kubectl top $resourceType $selectorString $kubeDebugString"
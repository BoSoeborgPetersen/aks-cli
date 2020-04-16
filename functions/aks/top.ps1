param($resourceType, $deploymentName)

$usage = Write-Usage "aks top <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "po" = "Show Pods."
    "no" = "Show Nodes."
}

if ($deploymentName) {
    Write-Info ("Show resource utilization of Kubernetes resources of type '$resourceType' for deployment '$deploymentName' in current AKS cluster '$($selectedCluster.Name)'")
}
else {
    Write-Info ("Show resource utilization of all Kubernetes resources of type '$resourceType' in current AKS cluster '$($selectedCluster.Name)'")
}

if ($deploymentName){
    Switch -Wildcard ($resourceType) {
        'po*' { 
            $selectorString = "-l='app=$deploymentName'"
        }
        'no*' { 
            $selectorString = ""
        }
    }
}

ExecuteCommand "kubectl top $resourceType $selectorString $kubeDebugString"
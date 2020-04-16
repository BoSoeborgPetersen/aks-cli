param($resourceType, $deploymentName)

$subCommands=@{
    "po" = "Show Pods."
    "no" = "Show Nodes."
}

if (!$resourceType)
{
    ShowSubMenu $command $subCommands
    exit
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
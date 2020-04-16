param($resourceType, $deploymentName)

$subCommands=@{
    "all" = "Show all standard Kubernetes resources."
    "svc" = "Show Services."
    "deploy" = "Show Deployments."
    "po" = "Show Pods."
    "no" = "Show Nodes."
    "rs" = "Show Replica Sets."
    "hpa" = "Show Horizontal Pod Autoscalers."
    "ing" = "Show Ingress."
    "secret" = "Show Secrets."
    "cert" = "Show Certificates."
    "issuer" = "Show Issuers."
    "order" = "Show Orders."
    "challenge" = "Show Challenges."
}

if (!$resourceType)
{
    ShowSubMenu $command $subCommands
    exit
}

if ($deploymentName) {
    Write-Info ("Show resources of type '$resourceType' for deployment '$deploymentName' in current AKS cluster '$($selectedCluster.Name)'")
}
else {
    Write-Info ("Show all resources of type '$resourceType' in current AKS cluster '$($selectedCluster.Name)'")
}

if ($deploymentName){
    Switch -Wildcard ($resourceType) {
        'all' { 
            $selectorString = ""
        }
        'svc' { 
            $selectorString = $deploymentName
        }
        'deploy*' { 
            $selectorString = $deploymentName
        }
        'po*' { 
            $selectorString = "-l='app=$deploymentName'"
        }
        'no*' { 
            $selectorString = ""
        }
        'rs' { 
            $selectorString = "-l='app=$deploymentName'"
        }
        'hpa' { 
            $selectorString = $deploymentName
        }
        'ing*' { 
            $selectorString = "$deploymentName-ingress"
        }
        'secret*' { 
            $selectorString = "$deploymentName-certificate"
        }
        'cert*' { 
            $selectorString = "$deploymentName-certificate"
        }
    }
}

ExecuteCommand "kubectl get $resourceType -o wide $selectorString $kubeDebugString"
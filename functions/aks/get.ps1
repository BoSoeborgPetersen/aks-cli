# TODO: Replace selector-string '-l' as it is not fixed, and use resource name prefix instead.
param($resourceType, $deploymentName)

$usage = Write-Usage "aks get <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
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

if ($deploymentName) {
    Write-Info ("Show resources of type '$resourceType' for deployment '$deploymentName'")
}
else {
    Write-Info ("Show all resources of type '$resourceType'")
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

ExecuteCommand "kubectl get $resourceType $selectorString $kubeDebugString"
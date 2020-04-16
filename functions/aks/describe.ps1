param($resourceType, $deploymentName)

$subCommands=@{
    "all" = "Describe all standard Kubernetes resources."
    "svc" = "Describe Services."
    "deploy" = "Describe Deployments."
    "po" = "Describe Pods."
    "no" = "Describe Nodes."
    "rs" = "Describe Replica Sets."
    "hpa" = "Describe Horizontal Pod Autoscalers."
    "ing" = "Describe Ingress."
    "secret" = "Describe Secrets."
    "cert" = "Describe Certificates."
    "issuer" = "Describe Issuers."
    "order" = "Describe Orders."
    "challenge" = "Describe Challenges."
}

if (!$resourceType)
{
    ShowSubMenu $command $subCommands
    exit
}

if ($deploymentName) {
    Write-Info ("Describe details of the first resource of type '$resourceType' for deployment '$deploymentName' in current AKS cluster '$($selectedCluster.Name)'")
    $selectorString = "-l='app=$deploymentName'"
}
else {
    Write-Info ("Describe details of the first resource of type '$resourceType' in current AKS cluster '$($selectedCluster.Name)'")
}

$podName = ExecuteQuery ("kubectl get po $selectorString -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")

ExecuteCommand ("kubectl describe $resourceType $podName $kubeDebugString")
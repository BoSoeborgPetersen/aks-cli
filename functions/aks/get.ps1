# TODO: Replace selector-string '-l' as it is not fixed, and use resource name prefix instead.
param($resourceType, $deploymentName)

$usage = Write-Usage "aks get <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "all" = "Show all standard Kubernetes resources."
    "cert" = "Show Certificates."
    "challenge" = "Show Challenges."
    "deploy" = "Show Deployments."
    "hpa" = "Show Horizontal Pod Autoscalers."
    "ing" = "Show Ingress."
    "issuer" = "Show Issuers."
    "no" = "Show Nodes."
    "order" = "Show Orders."
    "po" = "Show Pods."
    "rs" = "Show Replica Sets."
    "secret" = "Show Secrets."
    "svc" = "Show Services."
}

if ($deploymentName) {
    Write-Info ("Show resources of type '$resourceType' for deployment '$deploymentName'")
}
else {
    Write-Info ("Show all resources of type '$resourceType'")
}

ExecuteCommand "kubectl get $resourceType $selectorString $kubeDebugString"
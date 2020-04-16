# TODO: REWRITE!!!
# TODO: Add pod index to choose which pod.
# TODO: Add "All" option to describe all pods.
param($resourceType, $deploymentName)

$usage = Write-Usage "aks describe <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
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

if ($deploymentName) {
    Write-Info ("Describe details of the first resource of type '$resourceType' for deployment '$deploymentName'")
    $selectorString = "-l='app=$deploymentName'"
}
else {
    Write-Info ("Describe details of the first resource of type '$resourceType'")
}

$podName = ExecuteQuery ("kubectl get po $selectorString -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")

ExecuteCommand ("kubectl describe $resourceType $selectorString $kubeDebugString")
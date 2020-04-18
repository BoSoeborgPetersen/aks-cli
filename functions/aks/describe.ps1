# TODO: REWRITE!!!
# TODO: Add pod index to choose which pod.
# TODO: Add "All" option to describe all pods.
param($resourceType, $deploymentName)

$usage = Write-Usage "aks describe <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "all" = "Describe all standard Kubernetes resources."
    "cert" = "Describe Certificates."
    "challenge" = "Describe Challenges."
    "deploy" = "Describe Deployments."
    "hpa" = "Describe Horizontal Pod Autoscalers."
    "ing" = "Describe Ingress."
    "issuer" = "Describe Issuers."
    "no" = "Describe Nodes."
    "order" = "Describe Orders."
    "po" = "Describe Pods."
    "rs" = "Describe Replica Sets."
    "secret" = "Describe Secrets."
    "svc" = "Describe Services."
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
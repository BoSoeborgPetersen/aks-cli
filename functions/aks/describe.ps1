# TODO: REWRITE!!!
# TODO: Add pod index to choose which pod.
# TODO: Add "All" option to describe all pods.
# TODO: Add multi-choice commands (e.g. "po|pod|pods").
param($resourceType, $deploymentName)

$usage = Write-Usage "aks describe <resource type> [deployment name]"

VerifyCurrentCluster $usage

ValidateNoScriptSubCommand @{
    "all" = "Describe all standard Kubernetes resources."
    "certificate" = "Describe Certificates."
    "challenge" = "Describe Challenges."
    "deployment" = "Describe Deployments."
    "horizontalpodautoscaler" = "Describe Horizontal Pod Autoscalers."
    "ingress" = "Describe Ingress."
    "issuer" = "Describe Issuers."
    "node" = "Describe Nodes."
    "order" = "Describe Orders."
    "pod" = "Describe Pods."
    "replicaset" = "Describe Replica Sets."
    "secret" = "Describe Secrets."
    "service" = "Describe Services."
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
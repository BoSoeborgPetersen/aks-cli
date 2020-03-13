param($environmentName)

$usage = Write-Usage "aks devops environment replace-all <environment name> <cluster name>"

VerifyVariable $usage $environmentName "environment name"

Write-Host ("Removing Kubernetes resource from DevOps Environment '$environmentName, Namespace: default'")
#aks devops environment remove-kubernetes default
aks devops service-connection delete "$environmentName-default" default
Write-Host ("Removing Kubernetes resource from DevOps Environment '$environmentName, Namespace: ingress'")
#aks devops environment remove-kubernetes ingress
aks devops service-connection delete "$environmentName-ingress" ingress
Write-Host ("Removing Kubernetes resource from DevOps Environment '$environmentName, Namespace: cert-manager'")
#aks devops environment remove-kubernetes cert-manager
aks devops service-connection delete "$environmentName-cert-manager" cert-manager

Write-Host ("Deleting DevOps Environment '$environmentName'")
aks devops environment delete $environmentName
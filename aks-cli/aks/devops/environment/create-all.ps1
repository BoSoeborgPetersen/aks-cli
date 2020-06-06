param($environmentName)

WriteAndSetUsage "aks devops environment create-all <environment name>"

CheckVariable $environmentName "environment name"

Write-Host ("Creating DevOps Environment '$environmentName'")
aks devops environment create $environmentName

Write-Host ("Adding Kubernetes resource to DevOps Environment '$environmentName, Namespace: default'")
aks devops environment add-kubernetes $environmentName default 
Write-Host ("Adding Kubernetes resource to DevOps Environment '$environmentName, Namespace: ingress'")
aks devops environment add-kubernetes $environmentName ingress 
Write-Host ("Adding Kubernetes resource to DevOps Environment '$environmentName, Namespace: cert-manager'")
aks devops environment add-kubernetes $environmentName cert-manager 
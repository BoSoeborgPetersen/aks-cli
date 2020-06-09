# LaterDo: Add Approval/Check (e.g. '[Identity]\Contributors')
param($name, [switch] $addDefaultKubernetesResources)

WriteAndSetUsage "aks devops environment create" ([ordered]@{
    "<name>" = "Environment Name"
    "[-addDefaultKubernetesResources]" = "Add Kubernetes resources for default namespaces (default, ingress, cert-manager)"
})

CheckVariable $name "environment name"

Write-Info "Creating Environment"

$arguments = @{
    name = $name
}

$filepath = SaveTempFile($arguments)
AzDevOpsInvokeCommand -a environments -r environments -m POST -f $filepath
DeleteTempFile($filepath)

if ($addDefaultKubernetesResources)
{
    Write-Host ("Adding Kubernetes resource to DevOps Environment '$environment, Namespace: default'")
    AksCommand devops environment-kubernetes add $environment default 
    Write-Host ("Adding Kubernetes resource to DevOps Environment '$environment, Namespace: ingress'")
    AksCommand devops environment-kubernetes add $environment ingress 
    Write-Host ("Adding Kubernetes resource to DevOps Environment '$environment, Namespace: cert-manager'")
    AksCommand devops environment-kubernetes add $environment cert-manager 
}

# CREATE:
# POST https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234
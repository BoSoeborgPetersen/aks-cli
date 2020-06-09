param($name, [switch] $removeDefaultKubernetesResources)

WriteAndSetUsage "aks devops environment delete" ([ordered]@{
    "<name>" = "Environment Name"
    "[-removeDefaultKubernetesResources]" = "Remove Kubernetes resources for default namespaces (default, ingress, cert-manager)"
})

CheckVariable $name "environment name"

Write-Info "Deleting Environment"

if ($removeDefaultKubernetesResources)
{
    # TODO: Rewrite
    Write-Host ("Removing Kubernetes resource from DevOps Environment '$environment, Namespace: default'")
    #AksCommand devops environment remove-kubernetes default
    AksCommand devops service-connection delete "$environment-default" default
    Write-Host ("Removing Kubernetes resource from DevOps Environment '$environment, Namespace: ingress'")
    #AksCommand devops environment remove-kubernetes ingress
    AksCommand devops service-connection delete "$environment-ingress" ingress
    Write-Host ("Removing Kubernetes resource from DevOps Environment '$environment, Namespace: cert-manager'")
    #AksCommand devops environment remove-kubernetes cert-manager
    AksCommand devops service-connection delete "$environment-cert-manager" cert-manager
}

$id = AzDevOpsEnvironmentId $name
AzDevOpsInvokeCommand -a environments -r environments -p "environmentId=$id" -m DELETE

# DELETE:
# DELETE https://dev.azure.com/3Shape/Identity/_apis/pipelines/environments/234
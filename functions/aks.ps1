# LaterDo: Add nodepools to functions

# TODO: Add menu and functions for state (aks state debugging enable/disable, aks state verbose enable/disable, aks state resource-group set/unset) (get feedback)
#       - Maybe use 'PSDefaultParameterValue'.

# TODO: Add better examples to 'using' descriptions.

# TODO: When namespace parameter is not empty, then check that the namespace exists.
# TODO: Namespace: Allow '-A' for all namespaces.

# TODO: Use splatting to simplify long commands with many parameters (e.g. az aks create -c -n -g -?)..

# TODO: Add Azure "Get PublishSettings file" function, using this apparently very secret link 'https://portal.azure.com/#blade/Microsoft_Azure_ClassicResources/PublishingProfileBlade'

# LaterDo: Incorporate DevOps functions into all related functions
#          - e.g. update DevOps Service Connection when AKS cluster service principal is updated.
#          - e.g. update DevOps Variable Group (for Key Vault access) when Azure Key Vault service principal is updated.

[cmdletbinding(SupportsShouldProcess=$True)]
param
(
    [Parameter(ValueFromRemainingArguments=$True)]
    [string[]] $params
)

if (!$params)
{
    $params = @()
}

$global:GlobalRoot = $PSScriptRoot
. "$PSScriptRoot/helpers/powershell.ps1"
. "$PSScriptRoot/helpers/basic.ps1"
. "$PSScriptRoot/helpers/menu.ps1"
. "$PSScriptRoot/helpers/extensions.ps1"
. "$PSScriptRoot/helpers/check.ps1"
. "$PSScriptRoot/helpers/azure.ps1"
. "$PSScriptRoot/helpers/kubectl.ps1"
. "$PSScriptRoot/helpers/shared.ps1"
. "$PSScriptRoot/helpers/choose.ps1"
. "$PSScriptRoot/helpers/naming-convention.ps1"

CheckCurrentSubscription

MainMenu @{
    "cert-manager" = "Certificate Manager operations."
    "create" = "Create AKS cluster."
    "credentials" = "Get AKS cluster credentials."
    "current" = "Get current AKS cluster."
    "delete" = "Delete AKS cluster."
    "describe" = "Describe Kubernetes resources."
    "devops" = "Azure DevOps operations."
    "edit" = "Edit Kubernetes resource."
    "get" = "Get Kubernetes resources."
    "insights" = "AKS insights operations."
    "logs" = "Get container logs."
    "monitoring" = "Prometheus and Grafana operations."
    "nginx" = "NGINX Ingress operations."
    "node-autoscaler" = "Setup automatic AKS VM Scale Set scaling (Node scaling)."
    "pod-autoscaler" = "Setup automatic AKS deployment scaling (Pod scaling)."
    "pod-clean" = "Get rid of all failed pods in all namespaces."
    "pod-delete" = "Delete deployment pods"
    "pod-size" = "Get container disk space usage."
    "registry" = "Azure Container Registry operations."
    "scale-nodes" = "Scale AKS VM Scale Set (Node scaling)."
    "scale-pods" = "Scale AKS deployment (Pod scaling)."
    "service-principal" = "Azure Service Principal operations"
    # "setup" = "Install add-ons and configure AKS cluster."
    "shell" = "Open shell inside container."
    "switch" = "Switch Azure subscription/cluster."
    "tiller" = "Helm server side component."
    "top" = "Show Kubernetes resource utilization."
    # "traffic-manager" = "Azure Traffic Manager operations."
    "upgrade" = "Upgrade AKS cluster."
    "upgrades" = "Get AKS cluster upgradable versions."
    "version" = "Get AKS cluster version."
    "versions" = "Get AKS versions."
}
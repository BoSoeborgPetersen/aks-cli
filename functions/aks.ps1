# LaterDo: Add interactive nodepool menu
# LaterDo: Add nodepools to functions
# LaterDo: Add interactive namespace menu
# LaterDo: Add namespaces to functions

# TODO: All functions: Check ordering of parameter validation.
# TODO: Check if "--location/-l" can be removed in scripts.

# TODO: Add menu and functions for state (aks state debugging enable/disable, aks state verbose enable/disable, aks state resource-group set/unset) (get feedback)
#       - Maybe use 'PSDefaultParameterValue'.

# TODO: Come up with better names for global variables.

# TODO: Add better examples to 'using' descriptions.

# TODO: Use 'Write-Progress' instead of 'Write-Host' for progress messages (such as 'creating resource group '<resource group name').

# TODO: Use splatting to simplify long commands with many parameters (e.g. az aks create -c -n -g -?).

# MaybeDo: Use 'PSCredential' for passwords instead of string.

# MaybeDo: Add 'update-help' for powershell to Dockerfile.

# TODO: Add 'aks clean pod' that deletes all pods not in ready state.

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

. "$PSScriptRoot/basic.ps1"
. "$PSScriptRoot/menu.ps1"
. "$PSScriptRoot/shared.ps1"
. "$PSScriptRoot/naming-convention.ps1"

MainMenu @{
    "analytics" = "Azure Container Monitor operations"
    # "browse" = "Open Kubernetes dashboard."
    "cert-manager" = "Certificate Manager operations."
    "create" = "Create AKS cluster."
    "credentials" = "Get AKS cluster credentials."
    "current" = "Get current AKS cluster."
    "delete" = "Delete AKS cluster."
    "delete-pods" = "Delete deployment pods"
    "describe" = "Describe Kubernetes resources."
    "devops" = "Azure DevOps operations."
    "edit" = "Edit Kubernetes resource."
    "get" = "Get Kubernetes resources."
    "logs" = "Get container logs."
    "monitoring" = "Prometheus and Grafana operations."
    "nginx" = "NGINX Ingress operations."
    "node-autoscaler" = "Setup automatic AKS VM Scale Set scaling (Node scaling)."
    "pod-autoscaler" = "Setup automatic AKS deployment scaling (Pod scaling)."
    "pod-size" = "Get container disk space usage."
    "registry" = "Azure Container Registry operations."
    "scale-nodes" = "Scale AKS VM Scale Set (Node scaling)."
    "scale-pods" = "Scale AKS deployment (Pod scaling)."
    "service-principal" = "Azure Service Principal operations"
    "setup" = "Install add-ons and configure AKS cluster."
    "shell" = "Open shell inside container."
    "switch" = "Switch Azure subscription/cluster."
    "tiller" = "Helm server side component."
    "top" = "Show Kubernetes resource utilization."
    "traffic-manager" = "Azure Traffic Manager operations."
    "upgrade" = "Upgrade AKS cluster."
    "upgrades" = "Get AKS cluster upgradable versions."
    "version" = "Get AKS cluster version."
    "versions" = "Get AKS versions."
}
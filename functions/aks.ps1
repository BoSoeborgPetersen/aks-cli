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
    [Parameter(Position=0)][string]$arg0,
    [Parameter(Position=1)][string]$arg1,
    [Parameter(Position=2)][string]$arg2,
    [Parameter(Position=3)][string]$arg3,
    [Parameter(Position=4)][string]$arg4,
    [Parameter(Position=5)][string]$arg5,
    [Parameter(Position=6)][string]$arg6,
    [Parameter(Position=7)][string]$arg7,
    [Parameter(Position=8)][string]$arg8,
    [Parameter(Position=9)][string]$arg9,
    [Parameter(Position=10)][string]$arg10,
    [Parameter(Position=11)][string]$arg11
)

. "$PSScriptRoot/basic.ps1"
. "$PSScriptRoot/menu.ps1"
. "$PSScriptRoot/shared.ps1"
. "$PSScriptRoot/naming-convention.ps1"

MainMenu @{
    "analytics" = "Azure Monitor for containers - Monitor the performance of container workloads"
    # "browse" = "Opens the AKS dashboard."
    "cert-manager" = "Certificate Manager - Automatically provision and manage TLS certificates in Kubernetes."
    "create" = "Create AKS cluster."
    "credentials" = "Get AKS cluster credentials."
    "current" = "Get current AKS cluster."
    "delete" = "Delete AKS cluster."
    "delete-pods" = "Delete pods for deployment"
    "describe" = "Describe details for Kubernetes resources."
    "devops" = "Azure DevOps operations."
    "edit" = "Edit Kubernetes resource."
    "get" = "Show Kubernetes resources."
    "logs" = "Get Deployment logs."
    "monitoring" = "Monitoring with Prometheus and Grafana."
    "nginx" = "NGINX Ingress (Reverse Proxy Server) Controller for Kubernetes, which does SSL termination."
    "node-autoscaler" = "Scale AKS VMs automatically - Automatic node scaling."
    "pod-autoscaler" = "Scale AKS deployment automatically - Automatic pod scaling."
    "pod-size" = "Get Deployment Pod used disk space."
    "registry" = "Azure Container Registry operations."
    "scale-nodes" = "Scale AKS VMs - Manual node scaling."
    "scale-pods" = "Scale AKS deployment - Manual pod scaling."
    "service-principal" = "Azure Service Principal operations"
    "setup" = "Create Kubernetes cluster, install add-ons and configure both."
    "shell" = "Open shell inside container pod."
    "switch" = "(Interactive) Change current Azure subscription, AKS cluster or AKS deployment."
    "tiller" = "Helm server side component (Tiller)."
    "top" = "Show resource utilization for Kubernetes resources."
    "traffic-manager" = "Azure Traffic Manager operations"
    "upgrade" = "Upgrades AKS cluster."
    "upgrades" = "Get AKS cluster upgradable versions."
    "version" = "Get AKS cluster version."
    "versions" = "Get AKS versions."
}
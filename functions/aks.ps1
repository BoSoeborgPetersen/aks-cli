# LaterDo: Add Cool Theme from powershell Gallery

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
    [Parameter(Position=0)]
    [ValidateSet('current', 'switch', 'browse',
    'version', 'versions', 'upgrades', 'credentials',
    'create', 'upgrade', 'delete', 'delete-pods',
    'setup', 
    'tiller', 
    'nginx', 
    'monitoring', 
    'cert-manager',
    'analytics',
    'service-principal', 'traffic-manager', 
    'scale-pods', 'pod-autoscaler', 'scale-nodes', 'node-autoscaler',
    'get', 'top', 'edit', 'describe', 
    'logs', 'pod-size', 'shell',
    'configure-dns', 'registry',
    'devops')]
    [string]$command,
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

. "$PSScriptRoot/shared.ps1"
. "$PSScriptRoot/naming-convention.ps1"

function ShowUsage 
{
    $commands=@{
        "current" = "Get current AKS cluster."
        "switch" = "(Interactive) Change current Azure subscription, AKS cluster or AKS deployment."
        "browse" = "Opens the AKS dashboard."
        "version" = "Get AKS cluster version."
        "versions" = "Get AKS versions."
        "upgrades" = "Get AKS cluster upgradable versions."
        "credentials" = "Get AKS cluster credentials."
        # "" = ""
        "create" = "Create AKS cluster."
        "setup" = "Create Kubernetes cluster, install add-ons and configure both."
        "upgrade" = "Upgrades AKS cluster."
        "delete" = "Delete AKS cluster."
        "delete-pods" = "Delete pods for deployment"
        "configure-dns" = "Set AKS service IP DNS name prefixes to service names."
        "registry" = "Azure Container Registry operations."
        # ''
        "tiller" = "Helm server side component (Tiller)."
        "nginx" = "NGINX Ingress (Reverse Proxy Server) Controller for Kubernetes, which does SSL termination."
        "monitoring" = "Monitoring with Prometheus and Grafana."
        "cert-manager" = "Certificate Manager - Automatically provision and manage TLS certificates in Kubernetes."
        "analytics" = "Azure Monitor for containers - Monitor the performance of container workloads"
        "service-principal" = "Azure Service Principal operations"
        "traffic-manager" = "Azure Traffic Manager operations"
        # ''
        "scale-pods" = "Scale AKS deployment - Manual pod scaling."
        "pod-autoscaler" = "Scale AKS deployment automatically - Automatic pod scaling."
        "scale-nodes" = "Scale AKS VMs - Manual node scaling."
        "node-autoscaler" = "Scale AKS VMs automatically - Automatic node scaling."
        # ''
        "get" = "Show Kubernetes resources."
        "top" = "Show resource utilization for Kubernetes resources."
        "edit" = "Edit Kubernetes resource."
        "describe" = "Describe details for Kubernetes resources."
        "logs" = "Get Deployment logs."
        "pod-size" = "Get Deployment Pod used disk space."
        "shell" = "Open shell inside container pod."
    }

    Logo
    'Welcome to the AKS (Azure Kubernetes Service) CLI (aks)!'
    ''
    'Also available: Azure CLI (az), Kubernetes CLI (kubectl), Helm v2 & v3 CLI (helm & helm3)'
    'Also: Azure DevOps CLI extension (az devops), Curl, Git, Nano, PS-Menu'
    ''
    'Here are the commands:'
    ShowCommands $commands
    "e.g. try 'aks version'"
    ''
}

if (!$command) {
    ShowUsage
    exit
}

& "$PSScriptRoot\aks\$command.ps1" $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11
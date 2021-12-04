# TODO: Create workflow for creating AKS cluster and setting everything up (cluster, cluster setup, devops, traffic-manager), with 1 aks command.

# LaterDo: Improve functions for working with multiple nginx's in a cluster

# LaterDo: Add nodepools to functions

# LaterDo: Add better examples to 'using' descriptions.

# LaterDo: Add deployment history operations (e.g. aks deployment history consents).

# LaterDo: Incorporate DevOps functions into all related functions
#          - e.g. update DevOps Service Connection when AKS cluster service principal is updated.
#          - e.g. update DevOps Variable Group (for Key Vault access) when Azure Key Vault service principal is updated.

# MaybeDo: Use splatting to simplify long commands with many parameters (e.g. az aks create -c -n -g -?)..

# DoNotDo: Add Azure "Get PublishSettings file" function (requires classic azure cli), using this apparently very secret link 'https://portal.azure.com/#blade/Microsoft_Azure_ClassicResources/PublishingProfileBlade'

[cmdletbinding(SupportsShouldProcess=$True)]
param
(
    [Parameter(ValueFromRemainingArguments=$True)]
    [string[]] $params,
    [switch] $help
)

if (!$params)
{
    $params = @()
}

$global:GlobalRoot = $PSScriptRoot
Get-ChildItem "$PSScriptRoot/helpers/" -Filter *.ps1 -Recurse | ForEach-Object{ . $_.FullName }

CheckCurrentSubscription

MainMenu @{
    "az" = "Execute az command with -g and -n filled out"
    "autoscaler" = "Setup automatic pod or node scaling"
    "cert-manager" = "Certificate Manager operations"
    "create" = "Create AKS cluster"
    "delete" = "Delete AKS cluster"
    "describe" = "Describe Kubernetes resources"
    "devops" = "Azure DevOps operations"
    "edit" = "Edit Kubernetes resource"
    "get" = "Get Kubernetes resources"
    "identity" = "Azure Managed Identity operations"
    "insights" = "AKS insights operations"
    "invoke" = "Execute command in the current cluster"
    "keda" = "Keda (Kubernetes Event-driven Autoscaling) operations"
    "keyvault" = "Azure Key Vault operations"
    "kured" = "Kured (KUbernetes REboot Daemon) operations"
    "logs" = "Get container logs"
    "monitoring" = "Prometheus and Grafana operations"
    "nginx" = "Nginx operations"
    "pod" = "Kubernetes pod operations"
    "registry" = "Azure Container Registry operations"
    "release" = "Helm release operations (export/import)"
    # "replace" = "Replace AKS cluster operations"
    "resource-group" = "Azure Resource Group operations"
    "scale" = "Scale operations"
    "service-principal" = "Azure Service Principal operations"
    "setup" = "Create and setup AKS cluster"
    "shell" = "Open shell inside container"
    "show" = "Show AKS information"
    "state" = "Change default state operations"
    "switch" = "Switch Azure subscription / AKS cluster"
    "top" = "Show Kubernetes resource utilization"
    # "traffic-manager" = "Azure Traffic Manager operations"
    "upgrade" = "Upgrade AKS cluster"
    "upgrades" = "Get AKS cluster upgradable versions"
    "version" = "Get AKS cluster version"
    "versions" = "Get AKS versions"
    "vpa" = "Vertical Pod Autoscaler operations"
    "workload" = "Last-Applied-Config operations"
}
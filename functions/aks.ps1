# TODO: Add menu and functions for state (aks state debugging enable/disable, aks state verbose enable/disable, aks state resource-group set/unset) (get feedback)
#       - Maybe use 'PSDefaultParameterValue'.

# TODO: Add "aks registry create" function.

# TODO: When namespace parameter is not empty, then check that the namespace exists.

# TODO: Add "check" commands for everyting and then add Communicate script for checking that a cluster is as expected.

# LaterDo: Docker Image: Include funtions as built in functions

# LaterDo: Rename GitHub repo and Docker Hub registry to 'aks-cli', but write 'Azure Kubernetes Service CLI' in description.

# LaterDo: Add nodepools to functions

# LaterDo: Add better examples to 'using' descriptions.

# LaterDo: Add deployment history operations (e.g. aks deployment history consents).

# LaterDo: Incorporate DevOps functions into all related functions
#          - e.g. update DevOps Service Connection when AKS cluster service principal is updated.
#          - e.g. update DevOps Variable Group (for Key Vault access) when Azure Key Vault service principal is updated.

# MaybeDo: Add "aks keyvault create" function (trying to get rid of the need for it).

# MaybeDo: Use splatting to simplify long commands with many parameters (e.g. az aks create -c -n -g -?)..

# DoNotDo: Add Azure "Get PublishSettings file" function (requires classic azure cli), using this apparently very secret link 'https://portal.azure.com/#blade/Microsoft_Azure_ClassicResources/PublishingProfileBlade'

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
. "$PSScriptRoot/helpers/extensions.ps1"
. "$PSScriptRoot/helpers/powershell.ps1"
. "$PSScriptRoot/helpers/basic.ps1"
. "$PSScriptRoot/helpers/menu.ps1"
. "$PSScriptRoot/helpers/check.ps1"
. "$PSScriptRoot/helpers/shared.ps1"
. "$PSScriptRoot/helpers/current.ps1"
. "$PSScriptRoot/helpers/azure.ps1"
. "$PSScriptRoot/helpers/kubectl.ps1"
. "$PSScriptRoot/helpers/helm.ps1"
. "$PSScriptRoot/helpers/stern.ps1"
. "$PSScriptRoot/helpers/naming-convention.ps1"

CheckCurrentSubscription

MainMenu @{
    "autoscaler" = "Setup automatic pod or node scaling."
    "cert-manager" = "Certificate Manager operations."
    "create" = "Create AKS cluster."
    "current" = "Get current AKS cluster."
    "delete" = "Delete AKS cluster."
    "describe" = "Describe Kubernetes resources."
    "devops" = "Azure DevOps operations."
    "edit" = "Edit Kubernetes resource."
    "get" = "Get Kubernetes resources."
    "identity" = "Azure Managed Identity operations"
    "insights" = "AKS insights operations."
    "keyvault" = "Azure Key Vault operations."
    "logs" = "Get container logs."
    "monitoring" = "Prometheus and Grafana operations."
    "nginx" = "Nginx operations."
    "pod" = "Kubernetes pod operations."
    "registry" = "Azure Container Registry operations."
    # "replace" = "Replace AKS cluster operations."
    "resource-group" = "Azure Resource Group operations."
    "scale" = "Scale operations."
    "service-principal" = "Azure Service Principal operations"
    # "setup" = "Install add-ons and configure AKS cluster."
    "shell" = "Open shell inside container."
    "switch" = "Switch Azure subscription / AKS cluster."
    "tiller" = "Tiller (Helm v2 server side component) operations."
    "top" = "Show Kubernetes resource utilization."
    # "traffic-manager" = "Azure Traffic Manager operations."
    "upgrade" = "Upgrade AKS cluster."
    "upgrades" = "Get AKS cluster upgradable versions."
    "version" = "Get AKS cluster version."
    "versions" = "Get AKS versions."
}
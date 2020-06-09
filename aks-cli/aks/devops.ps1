$organization = DevOpsOrganizationName
$project = DevOpsProjectName
az devops configure --defaults organization=https://dev.azure.com/$organization/ project=$project

SubMenu @{
    "check" = "Check Azure DevOps (Environment, Pipeline & Service-Connection)"
    "environment" = "Azure DevOps Environment operations"
    "environment-checks" = "Azure DevOps Environment Checks operations"
    "environment-kubernetes" = "Azure DevOps Environment Kubernetes resource operations"
    "pipeline" = "Azure DevOps Pipeline operations"
    "replace-cluster" = "Azure DevOps - Replace service-connection, environment and run pipelines"
    "service-connection" = "Azure DevOps Service-Connection operations"
}
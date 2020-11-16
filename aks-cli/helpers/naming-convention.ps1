function ClusterName($resourceGroup)
{
    return "$resourceGroup-aks"
}

function InsightsName($resourceGroup)
{
    return "$resourceGroup-aks-insights"
}

function RegistryName($resourceGroup)
{
    $middle = $resourceGroup.Split('-')[1]
    return "gl-$middle-acr"
}

function KeyVaultName($resourceGroup)
{
    $middle = $resourceGroup.Split('-')[1]
    return "gl-$middle-aks-vault"
}

function GlobalResourceGroupName($resourceGroup)
{
    $middle = $resourceGroup.Split('-')[1]
    return "gl-$middle"
}

function PublicIpName($prefix, $cluster)
{
    return PrependWithDash -prefix $prefix -string "$cluster-ip"
}

function ServicePrincipalName($cluster)
{
    return "http://$cluster-principal"
}

function ServicePrincipalIdName($cluster)
{
    return "$cluster-principal-id"
}

function ServicePrincipalPasswordName($cluster)
{
    return "$cluster-principal-password"
}

function CertManagerDeploymentName
{
    return "cert-manager"
}

function NginxDeploymentName($prefix)
{
    return PrependWithDash $prefix "nginx-ingress"
}

function KuredDeploymentName
{
    return "kured"
}

# LaterDo: Is there any way to determine this.
function DevOpsOrganizationName
{
    return "3Shape"
}

# LaterDo: Is there any way to determine this.
function DevOpsProjectName
{
    return "Services"
}

function DevOpsUnixName($name)
{
    return ($name.ToLower() -replace ' - ',' ') -replace '\W','-'
}

function DevOpsServiceAccountName($name)
{
    $unixName = DevOpsUnixName $name
    return "$unixName-devops-sa"
}

function DevOpsRoleBindingName($name)
{
    $unixName = DevOpsUnixName $name
    return "$unixName-devops-rb"
}

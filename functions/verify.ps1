function VerifyCurrentSubscription()
{
    if (!$GlobalCurrentSubscription) {
        WriteUsage
        Write-Error "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
        exit
    }
}

function VerifyCurrentCluster()
{
    if (!$GlobalCurrentCluster) {
        WriteUsage
        Write-Error "No current AKS cluster, run 'aks switch cluster' to select a current AKS cluster"
        exit
    }
}

function VerifyCurrentClusterOrVariable($variable, $variableName)
{
    if (!$GlobalCurrentCluster -and $variable) {
        WriteUsage
        Write-Error "The following argument is required: $variableName"
        Write-Error "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used"
        exit
    }
}

function VerifyVariable($variable, $variableName)
{
    if (!$variable) {
        WriteUsage
        Write-Error "The following argument is required: <$variableName>"
        exit
    }
}
function VerifyVersion($version)
{
    if (!($version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"))
    {
        WriteUsage
        Write-Error "The specified version '$version' is not a valid Semantic Version (e.g. '0.14')"
        exit
    }
}

function CheckLocationExists($location)
{
    $locationExists = ExecuteQuery "az account list-locations --query `"[?name=='$location'].name`" -o tsv"
    if (!$locationExists)
    {
        WriteUsage
        Write-Error "Location '$location' does not exist"
        exit
    }
}

function CheckVersionExists($version, $preview)
{
    VerifyVersion $version

    $previewString = ConditionalOperator (!$preview) "!isPreview &&"

    $versionExists = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query `"controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$version'].kubernetesVersion`" -o tsv"

    if (!$versionExists)
    {
        WriteUsage
        Write-Error "Version '$version' does not exist"
        exit
    }
}

function ValidateNumberType([ref] $variable, $variableName)
{
    if (!($variable.Value -match "^\d+$"))
    {
        WriteUsage
        Write-Error "Invalid variable <$variableName>, not a valid number '$($variable.Value)'"
        exit
    }
    $variable.Value = [int]$variable.Value
}

function ValidateNumberRange([ref] $variable, $variableName, $min, $max)
{
    VerifyVariable $variable.Value $variableName
    ValidateOptionalNumberRange $variable $variableName $min $max
}

function ValidateOptionalNumberRange([ref] $variable, $variableName, $min, $max)
{
    if($variable.Value)
    {
        ValidateNumberType $variable $variableName
    
        $valid = ($variable.Value -ge $min -and $variable.Value -le $max)
        if (!$valid){
            WriteUsage
            Write-Error "Invalid variable <$variableName>, value outside range ($min - $max)"
            exit
        }
    }
}

function ValidateBooleanType($variable, $variableName)
{
    if (!($variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$"))
    {
        WriteUsage
        Write-Error ("$($variableName): Not a boolean '$variable'")
        exit
    }
}
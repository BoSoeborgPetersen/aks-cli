function Check($check, $errorMessage)
{
    if (!$check) {
        WriteUsage
        Write-Error $errorMessage
        exit
    }
}

function CheckCurrentSubscription()
{
    Check $GlobalCurrentSubscription "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
}

function CheckCurrentCluster()
{
    Check $GlobalCurrentCluster "No current AKS cluster, run 'aks switch cluster' to select a current AKS cluster"
}

function CheckCurrentClusterOrVariable($variable, $variableName)
{
    $check = $GlobalCurrentCluster -or $variable
    Check $check ("The following argument is required: $variableName" + "\n" + "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used")
}

function CheckVariable($variable, $variableName)
{
    Check $variable "The following argument is required: <$variableName>"
}

function CheckVersion($version)
{
    $check = $version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"
    Check $check "The specified version '$version' is not a valid Semantic Version (i.e. 'x.y.z')"
}

function CheckNumberType($variable, $variableName)
{
    $check = $variable -match "^\d+$"
    Check $check "Invalid variable <$variableName>, not a valid number '$variable'"
}

function CheckOptionalNumberRange($variable, $variableName, $min, $max)
{
    if($variable)
    {
        CheckNumberType $variable $variableName

        $rangeCheck = $variable -ge $min -and $variable -le $max
        Check $rangeCheck "Invalid variable <$variableName>, value '$variable' outside range ($min - $max)"
    }
}

function CheckNumberRange([ref] $variable, $variableName, $min, $max, $default)
{
    if ($default)
    {
        SetDefaultIfEmpty $variable $default
    }
    CheckVariable $variable.Value $variableName
    CheckOptionalNumberRange $variable $variableName $min $max
}

function CheckBooleanType($variable, $variableName)
{
    $rangeCheck = $variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$"
    Check $rangeCheck "$($variableName): Not a boolean '$variable'"
}
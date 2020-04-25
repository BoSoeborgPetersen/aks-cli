function Check($check, [string] $errorMessage)
{
    if (!$check) {
        WriteUsage
        Write-Error $errorMessage
        exit
    }
}

function CheckCurrentSubscription()
{
    $check = $GlobalCurrentSubscription -or ($params[0] -eq "switch")
    Check $check "No current Azure subscription, run 'aks switch subscription' to select a current Azure subscription"
}

function CheckCurrentCluster()
{
    Check $GlobalCurrentCluster "No current AKS cluster, run 'aks switch cluster' to select a current AKS cluster"
}

function CheckCurrentClusterOrVariable($variable, [string] $variableName)
{
    $check = $GlobalCurrentCluster -or $variable
    Check $check ("The following argument is required: $variableName" + "\n" + "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used")
}

function CheckVariable($variable, [string] $variableName)
{
    Check $variable "The following argument is required: <$variableName>"
}

function CheckVersion([string] $version)
{
    $check = $version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"
    Check $check "The specified version '$version' is not a valid Semantic Version (i.e. 'x.y.z')"
}

function CheckNumberType([string] $variable, [string] $variableName)
{
    $check = $variable -match "^\d+$"
    Check $check "Invalid variable <$variableName>, not a valid number '$variable'"
}

function CheckOptionalNumberRange([string] $variable, [string] $variableName, [int] $min, [int] $max)
{
    if($variable)
    {
        CheckNumberType $variable $variableName
        $number = $variable -as [int]
        $rangeCheck = $number -ge $min -and $number -le $max
        Check $rangeCheck "Invalid variable <$variableName>, value '$variable' outside range ($min - $max)"
    }
}

function CheckNumberRange([ref][string] $variable, [string] $variableName, [int] $min, [int] $max, [int] $default)
{
    if ($default)
    {
        SetDefaultIfEmpty $variable $default
    }
    CheckVariable $variable.Value $variableName
    CheckOptionalNumberRange $variable $variableName $min $max
}

function CheckBooleanType([string] $variable, [string] $variableName)
{
    $rangeCheck = $variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$"
    Check $rangeCheck "$($variableName): Not a boolean '$variable'"
}
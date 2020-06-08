function Check($check, [string] $errorMessage)
{
    if (!$check) {
        WriteUsage
        Write-Error $errorMessage
        exit
    }
}

function CheckVariable($variable, [string] $variableName)
{
    Check $variable "The following argument is required: <$variableName>"
}

function CheckSemanticVersion([string] $version)
{
    return $version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"
}

# LaterDo: Finish
# function ConvertSemanticVersionToShort([string] $version)
# {
#     $noPatchVersion = $version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"
#     $shortVersionString = ConditionalOperator ((CheckSemanticVersion $version -and $noPatchVersion)) "" $version.Replace('.0', '') 
# }

function CheckVersion([ref][string] $version, [string] $default)
{
    SetDefaultIfEmpty $version $default
    $check = CheckSemanticVersion $version.Value
    Check $check "The specified version '$($version.Value)' is not a valid Semantic Version (i.e. 'x.y.z')"
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
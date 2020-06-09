function Check($check, $errorMessage)
{
    if (!$check) 
    {
        WriteUsage
        Write-Error $errorMessage -exitOnError
    }
}

function CheckVariable($variable, $variableName)
{
    Check $variable "The following argument is required: <$variableName>"
}

function CheckSemanticVersion($version)
{
    return $version -match "^[\d]+(\.[\d]+)?(\.[\d]+)?$"
}

function CheckVersion($version, $default)
{
    $version = SetDefaultIfEmpty $version $default
    $check = CheckSemanticVersion $version
    Check $check "The specified version '$version' is not a valid Semantic Version (i.e. 'x.y.z')"
    return $version
}

function CheckNumberType($variable, $variableName)
{
    $check = $variable -match "^\d+$"
    Check $check "Invalid variable <$variableName>, not a valid number '$variable'"
}

function CheckOptionalNumberRange($variable, $variableName, [int] $min, [int] $max)
{
    if ($variable)
    {
        CheckNumberType $variable $variableName
        $number = $variable -as [int]
        $rangeCheck = $number -ge $min -and $number -le $max
        Check $rangeCheck "Invalid variable <$variableName>, value '$variable' outside range ($min - $max)"
    }
}

function CheckNumberRange($variable, $variableName, [int] $min, [int] $max, [int] $default)
{
    if ($default)
    {
        $variable = SetDefaultIfEmpty $variable $default
    }

    CheckVariable $variable $variableName
    CheckOptionalNumberRange $variable $variableName $min $max
}

function CheckBooleanType($variable, $variableName)
{
    $rangeCheck = $variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$"
    Check $rangeCheck "$($variableName): Not a boolean '$variable'"
}
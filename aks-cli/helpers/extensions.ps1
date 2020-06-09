function SetDefaultIfEmpty($variable, $default)
{
    if ($variable)
    {
        return $variable
    }
    
    return $default
}

function PrependWithDash($prefix, $string)
{
    return ConditionalOperator $prefix "$prefix-$string" $string
}

function ConditionalOperator($test, $value1, $value2 = "")
{
    if ($test)
    {
        return $value1
    }
    
    return $value2
}
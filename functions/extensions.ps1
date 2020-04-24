function SetDefaultIfEmpty([ref] $variable, $defaultValue)
{
    if (!$variable.Value){
        $variable.Value = $defaultValue
    }
}

function PrependWithDash($name, $prefix)
{
    if ($prefix)
    {
        return "$prefix-$name"
    }
    else 
    {
        return $name
    }
}

function ConditionalOperator($test, $value1, $value2 = "")
{
    $variable = $value2
    if ($test)
    {
        $variable = $value1
    }
    return $variable
}

function ArrayTakeIndexOrFirst($array, $index)
{
    if ($index)
    {
        return $array | Select-Object -Index ($index - 1)
    }
    else 
    {
        return $array | Select-Object -First 1
    }
}

function CamelCaseToSpaceDelimited($variable)
{
    return "Not Implemented!"
}
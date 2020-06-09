function WriteAdvancedHelp($usage, $parameters)
{
    Logo
    $command = $usage
    $commandText = CurrentCommandText
    Write-Host 'Command'
    Write-Host "    $command : $commandText"
    Write-Host ''
    Write-Host 'Arguments'

    $hasRequiredParameters = ($parameters.Keys | Where-Object {$_ -Match "^<.*>$"}).Length -ge 1
    $maxParameterKeyLength = (($parameters.Keys | Measure-Object -Maximum -Property Length).Maximum -2)
    $maxParameterKeyLength = ConditionalOperator $hasRequiredParameters ($maxParameterKeyLength +11) $maxParameterKeyLength
    if ($parameters.Length -ge 1)
    {
        foreach ($key in $parameters.Keys)
        {
            if ($key -match "^<.*>$")
            {
                $cleanKey = $key -replace '^<' -replace '>$'
                Write-Host "    $($cleanKey.PadRight($maxParameterKeyLength -8)) [Required] : $($parameters.$key)"
            }
            else
            {
                $cleanKey = $key -replace '^\[' -replace '\]$'
                Write-Host "    $($cleanKey.PadRight($maxParameterKeyLength +3)) : $($parameters.$key)"
            }
        }
    }
    else 
    {
        Write-Host "    <none>"
    }

    Write-Host ''
    ShowGeneralFlags
}

function WriteAdvancedUsage($usage, $parameters)
{
    $parametersString = $parameters.Keys -Join ' '
    $usageText = "Usage: $usage $parametersString"
    $global:GlobalUsage = $usageText
    Write-Verbose $usageText
}

function WriteAndSetUsage($usage, $parameters)
{
    if ($help)
    {
        WriteAdvancedHelp $usage $parameters
        exit
    }

    WriteAdvancedUsage $usage $parameters
}

function WriteUsage
{
    Write-Info $GlobalUsage
}

function ExecuteCommand($command)
{
    if (!$whatIf)
    {
        Write-Verbose "COMMAND: $Command"
        
        return Invoke-Expression $Command
    }
    else 
    {
        Write-Info "WhatIf: $Command"
    }
}

function ExecuteQuery($query)
{
    Write-Verbose "QUERY: $query"
    
    $result = Invoke-Expression $query

    Write-Verbose "QUERY - RESULT: $result"

    return $result
}

function AksCommand
{
    param(
        [string]$command,
        [Parameter(ValueFromRemainingArguments=$True)]
        [string[]] $params
    )

    $command = "aks $command $params"

    Write-Verbose "COMMAND: $Command"
    
    return Invoke-Expression $Command
}
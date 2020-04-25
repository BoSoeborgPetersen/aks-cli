function WriteAndSetUsage($usageText)
{
    $global:GlobalUsage = "Usage: $usageText"
    Write-Verbose $GlobalUsage
}

function WriteUsage()
{
    Write-Info $GlobalUsage
}

function ExecuteCommand($commandString)
{
    if(!$whatIf)
    {
        Write-Verbose "COMMAND: $CommandString"
        
        return Invoke-Expression $CommandString
    }
    else 
    {
        Write-Info "WhatIf: $CommandString"
    }
}

function ExecuteQuery($commandString)
{
    Write-Verbose "QUERY: $CommandString"
    
    return Invoke-Expression $CommandString
}
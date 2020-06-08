function WriteHelp($usageText)
{
    Logo
    Write-Host $usageText
    Write-Host ''
    $command = $usageText -replace '\[.*\]' -replace '\<.*\>' -replace '[\s]*$'
    $commandText = GetCurrentCommandText
    $arguments = $usageText -replace '^[^\[<]*' -split '<' -split '\['
    Write-Host 'Command'
    Write-Host "    $command : $commandText"
    Write-Host ''
    Write-Host 'Required Arguments'
    $requiredArguments = $arguments | Where-Object {$_ -Match ".*>"}
    if ($requiredArguments.Length -ge 1)
    {
        foreach ($argument in $requiredArguments)
        {
            Write-Host "    $($argument -replace '>')"
        }
    }
    else 
    {
        Write-Host "    <none>"
    }
    Write-Host ''
    Write-Host 'Optional Arguments'
    $optionalArguments = $arguments | Where-Object {$_ -Match ".*\]"}
    if ($optionalArguments.Length -ge 1)
    {
        foreach ($argument in $optionalArguments)
        {
            Write-Host "    $($argument -replace '\]')"
        }
    }
    else 
    {
        Write-Host "    <none>"
    }
    Write-Host ''
    ShowGeneralFlags
}

function WriteAndSetUsage($usageText)
{
    $global:GlobalUsage = "Usage: $usageText"
    if ($help)
    {
        WriteHelp $usageText
        exit
    }
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
    
    $result = Invoke-Expression $CommandString

    Write-Verbose "QUERY - RESULT: $result"

    return $result
}
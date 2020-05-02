function Write-Error($message) 
{
    [Console]::ForegroundColor = 'red'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-InfoMessage($message) 
{
    [Console]::ForegroundColor = 'darkcyan'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-Info($message, [string] $regex, [string] $index, [string] $namespace) 
{
    $regexString = ConditionalOperator $regex "matching '$regex'"
    $indexString = ConditionalOperator $index "with index '$index'"
    $namespaceString = ConditionalOperator $namespace "in namespace '$namespace'"
    Write-InfoMessage "$message $regexString $indexString $namespaceString"
}

if ($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent)
{
    $debugString = "--debug"
    $kubeDebugString = "--v=4"
}

if ($PSCmdlet.MyInvocation.BoundParameters["WhatIf"].IsPresent)
{
    $whatIf = $true
}

function UpdateShellWindowTitle()
{
    $cluster = GetCurrentClusterName
    $host.ui.RawUI.WindowTitle = $cluster
}

function UpdateShellPrompt()
{
    function global:prompt
    {
        Write-Host "AKS $(get-location)" -NoNewline
        Write-Host " [" -ForegroundColor Yellow -NoNewline
        Write-Host (GetCurrentClusterName) -ForegroundColor Cyan -NoNewline
        Write-Host "]" -ForegroundColor Yellow -NoNewline
        Write-Host " >" -NoNewline
        return " "
    }
}
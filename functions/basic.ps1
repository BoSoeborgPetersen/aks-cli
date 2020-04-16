function Write-Error($message) {
    [Console]::ForegroundColor = 'red'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-Info($message) {
    [Console]::ForegroundColor = 'darkcyan'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-Usage($usageText)
{
    $usage = "Usage: $usageText"
    Write-Verbose $usage
    return $usage
}

if ($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent){
    $debugString = "--debug"
    $kubeDebugString = "--v=4"
}

if ($PSCmdlet.MyInvocation.BoundParameters["WhatIf"].IsPresent){
    $dryrun = $true
}
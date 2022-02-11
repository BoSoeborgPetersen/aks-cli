if (!$GlobalRunOnce)
{
    $global:GlobalIsDevelopment = Test-Path /app/dev-aks-cli
    $global:GlobalRunOnce = $true
}

if ($GlobalStateDebugging -or $PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent)
{
    $debugString = " --debug"
    $kubeDebugString = " --v=4"
}

if ($GlobalStateWhatIf -or $PSCmdlet.MyInvocation.BoundParameters["WhatIf"].IsPresent)
{
    $whatIf = $true
}

if ($GlobalStateVerbose)
{
    $VerbosePreference = "Continue"
}

function SetDebuggingState($disable)
{
    $global:GlobalStateDebugging = (!$disable)
}

function SetWhatIfState($disable)
{
    $global:GlobalStateWhatIf = (!$disable)
}

function SetVerboseState($disable)
{
    $global:GlobalStateVerbose = (!$disable)
}

function SetDefaultResourceGroup($resourceGroup)
{
    $global:GlobalDefaultResourceGroup = $resourceGroup
}

function DefaultResourceGroup
{
    return $global:GlobalDefaultResourceGroup
}

function Write-ErrorMessage($message) 
{
    [Console]::ForegroundColor = 'red'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-Error($message, $regex, $index, $namespace, [switch] $exitOnError) 
{
    $regexString = ConditionalOperator $regex " matching '$regex'"
    $indexString = ConditionalOperator ($index -and $index -ne 0) " with index '$index'"
    $namespaceString = ConditionalOperator $namespace " in namespace '$namespace'"

    Write-ErrorMessage ($message + $regexString + $indexString + $namespaceString)
    
    if ($exitOnError)
    {
        exit
    }
}

function Write-InfoMessage($message) 
{
    [Console]::ForegroundColor = 'darkcyan'
    [Console]::Error.WriteLine($message)
    [Console]::ResetColor()
}

function Write-Info($message, $regex, $index, $namespace, [switch] $exit) 
{
    $regexString = ConditionalOperator $regex " matching '$regex'"
    $indexString = ConditionalOperator ($index -and $index -ne 0) " with index '$index'"
    $namespaceString = ConditionalOperator $namespace " in namespace '$namespace'"

    Write-InfoMessage ($message + $regexString + $indexString + $namespaceString)

    if ($exit)
    {
        exit
    }
}

function UpdateShellWindowTitle
{
    $host.ui.RawUI.WindowTitle = (CurrentClusterName) + (ConditionalOperator $GlobalIsDevelopment ' (dev)')
}
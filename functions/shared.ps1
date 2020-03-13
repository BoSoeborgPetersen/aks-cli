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

# TODO: Try to show menu on error or debug stream instead of output stream.
function ChooseAzureAccount()
{
    if(!$accounts){
        $global:accounts = az account list | ConvertFrom-Json
    }
    if ($accounts.length -eq 1)
    {
        return $accounts[0]
    }
    if ($accounts.length -eq 0)
    {
        Write-Error "No Azure subscriptions/accounts"
        exit
    }
    $selectedAccountIndex = menu @($accounts | Foreach-Object { $_.name }) -ReturnIndex
    return $accounts[$selectedAccountIndex]
}

# TODO: Try to show menu on error or debug stream instead of output stream.
# TODO: Handle no choosen Azure Subscription.
function ChooseAksCluster()
{
    if (!$accountUsedForClusters -or !$clusters -or ($selectedAccount -ne $accountUsedForClusters))
    {
        $global:accountUsedForClusters = $selectedAccount
        $global:clusters = az aks list | ConvertFrom-Json
    }
    if ($clusters.length -eq 1)
    {
        return $clusters[0]
    }
    if ($clusters.length -eq 0)
    {
        Write-Error "No AKS clusters in Azure subscription/account"
        exit
    }
    $selectedClusterIndex = menu @($clusters | Foreach-Object { $_.name }) -ReturnIndex
    return $clusters[$selectedClusterIndex]
}

# TODO: Try to show menu on error or debug stream instead of output stream.
# TODO: Handle no choosen Azure Subscription.
# TODO: Handle no choosen AKS cluster.
function ChooseKubernetesDeploymentName()
{
    if (!$accountUsedForDeployments -or !$clusterUsedForDeployments -or !$globalDeploymentNames -or ($selectedAccount -ne $accountUsedForDeployments) -or ($selectedCluster -ne $clusterUsedForDeployments))
    {
        $global:accountUsedForDeployments = $selectedAccount
        $global:clusterUsedForDeployments = $selectedCluster
        $global:globalDeploymentNames = (ExecuteQuery "kubectl get deploy -o jsonpath='{.items[*].metadata.name}'") -split ' '
    }
    if ($globalDeploymentNames.length -eq 1)
    {
        return $globalDeploymentNames[0]
    }
    if ($globalDeploymentNames.length -eq 0)
    {
        Write-Error "No Kubernetes deployments in AKS cluster"
        exit
    }
    return menu $globalDeploymentNames
}

function DeploymentChoiceMenu([ref] $deploymentName)
{
    if (!$deploymentName.Value)
    {
        Clear-Host
        Write-Info "Choose AKS Deployment: "
        $deploymentName.Value = ChooseKubernetesDeploymentName
    }
}

function ChooseAksDeployment()
{
    Clear-Host
    Write-Info "Choose AKS Deployment: "
    $global:globalDeploymentName = ChooseKubernetesDeploymentName
}

function Logo()
{
    Write-Host ''
    Write-Host '      __       __   ___   _______  '
    Write-Host '     /  \     |  | /  /  |  _____| '
    Write-Host '    /    \    |  |/  /   |  |____  '
    Write-Host '   /  /\  \   |     |    |____   | '
    Write-Host '  /  ____  \  |  |\  \    ____|  | '
    Write-Host ' /__/    \__\ |__| \__\  |_______| '
    Write-Host ''
}

function ShowCommands($commands)
{
    Write-Host ''
    $maxSubCommandLength = ($commands.Keys | Measure-Object -Maximum -Property Length).Maximum
    ForEach ($key in ($commands.Keys | Sort-Object)) {
        Write-Host ("    $($key.PadRight($maxSubCommandLength + 4)): $($commands["$key"])")
    }
    Write-Host ''
}

function ShowSubMenu($command, $subCommands)
{
    Logo
    Write-Host "aks $command <sub-command>"
    Write-Host ''
    Write-Host 'Here are the sub-commands:'
    ShowCommands $subCommands
    Write-Host ("e.g. 'aks $command $($subCommands.keys[0] | Select-Object -first 1)'")
    Write-Host ''
}

function ValidateSubMenu($pathPrefix, $command, $subCommand, $subCommands)
{
    if (!$subCommand) {
        ShowSubMenu $command $subCommands
        exit
    }
    
    if (!$subCommands.Contains($subCommand)) {
        Write-Error "Invalid sub command: $subCommand"
        ShowSubMenu $command $subCommands
        exit
    }
    
    $path = "$pathPrefix/$command/$subCommand.ps1"
    $scriptExists = [System.IO.File]::Exists($path)
    if (!$scriptExists) {
        Write-Error "Script for sub command does not exist: $path"
        ShowSubMenu $command $subCommands
        exit
    }

    return $path
}

function SubMenu($pathPrefix, $command, $subCommand, $subCommands)
{
    $path = ValidateSubMenu $pathPrefix $command $subCommand $subCommands

    & $path $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11
}

function SubSubMenu($pathPrefix, $command, $subCommand, $subCommands)
{
    $path = ValidateSubMenu $pathPrefix $command $subCommand $subCommands

    & $path $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 $arg11
}

if ($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent){
    $debugString = "--debug"
    $kubeDebugString = "--v=4"
}

if ($PSCmdlet.MyInvocation.BoundParameters["WhatIf"].IsPresent){
    $dryrun = $true
}

function VerifyCurrentSubscription($usage)
{
    if (!$selectedAccount) {
        Write-Info $usage
        Write-Error "No current Azure subscription, run 'aks switch account' to select a current Azure subscription"
        exit
    }
}

function VerifyCurrentCluster($usage)
{
    if (!$selectedCluster) {
        Write-Info $usage
        Write-Error "No current AKS cluster, run 'aks switch cluster' to select a current AKS cluster"
        exit
    }
}

function VerifyCurrentClusterOrVariable($usage, $variable, $variableName)
{
    if (!$selectedCluster -and $variable) {
        Write-Info $usage
        Write-Error "The following argument is required: $variableName"
        Write-Error "Alternatively run 'aks switch' to select a current AKS cluster, then the current cluster '$variableName' will be used"
        exit
    }
}

function VerifyVariable($usage, $variable, $variableName)
{
    if (!$variable) {
        Write-Info $usage
        Write-Error "The following argument is required: <$variableName>"
        exit
    }
}

function SetDefaultIfEmpty([ref] $variable, $defaultValue){
    if (!$variable.Value){
        $variable.Value = $defaultValue
    }
}

function ValidateNumberType($usage, [ref] $variable, $variableName){
    if (!($variable.Value -match "^\d+$")){
        Write-Info $usage
        Write-Error "Invalid variable <$variableName>, not a valid number '$variable'"
        exit
    }
    $variable.Value = [int]$variable.Value
}

function ValidateNumberRange($usage, [ref] $variable, $variableName, $min, $max){
    VerifyVariable $usage $variable.Value $variableName
    ValidateNumberType $usage $variable $variableName

    $valid = ($variable.Value -gt $min -and $variable.Value -lt $max)
    if (!$valid){
        Write-Info $usage
        Write-Error "Invalid variable <$variableName>, value outside range ($min - $max)"
        exit
    }
}

function ValidateBooleanType($usage, $variable, $variableName){
    if (!($variable -match "^(FALSE|TRUE|False|True|false|true|0|1)$")){
        Write-Info $usage
        Write-Error ("$($variableName): Not a boolean '$variable'")
        exit
    }
}

function Write-Usage($usageText)
{
    $usage = "Usage: $usageText"
    Write-Verbose $usage
    return $usage
}

function ExecuteCommand($commandString)
{
    if(!$dryrun)
    {
        Write-Verbose "COMMAND: $CommandString"
        
        return Invoke-Expression $CommandString
    }
    else 
    {
        Write-Info "What if: $CommandString"
    }
}

function ExecuteQuery($commandString)
{
    Write-Verbose "QUERY: $CommandString"
    
    return Invoke-Expression $CommandString
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
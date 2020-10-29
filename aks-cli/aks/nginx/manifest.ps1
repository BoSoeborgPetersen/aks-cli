param($configPrefix)

WriteAndSetUsage ([ordered]@{
    "[config prefix]" = "AKS-CLI config file name prefix"
})

CheckCurrentCluster
$configFile = PrependWithDash $configPrefix "nginx-config.yaml"

Write-Info "Edit manifest config file (yaml) used for installing Nginx"

ExecuteCommand "nano $PSScriptRoot/config/$configFile"
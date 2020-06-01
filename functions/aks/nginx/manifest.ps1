param($configPrefix)

WriteAndSetUsage "aks nginx manifest"

CheckCurrentCluster
$configFile = PrependWithDash "nginx-config.yaml" $configPrefix

Write-Info "Edit manifest config file (yaml) used for installing Nginx"

ExecuteCommand "nano $PSScriptRoot/config/$configFile"
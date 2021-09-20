param($command)

WriteAndSetUsage ([ordered]@{
    "<type>" = "Command"
})

CheckCurrentCluster

Write-Info "Invoke '$command'"

AzAksCurrentCommand "command invoke -c `"$command`""
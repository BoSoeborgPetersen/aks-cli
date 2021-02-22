param
(
[Parameter(ValueFromRemainingArguments=$True)]
[string[]] $params
)

WriteAndSetUsage ([ordered]@{
    "<params>" = "Multiple parameters"
})

CheckCurrentCluster

# Write-Info "Get '$type'" -r $regex -n $namespace

AzAksCurrentCommand "$params"
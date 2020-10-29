param([switch] $disable)

WriteAndSetUsage ([ordered]@{
    "[-disable]" = "Flag to disable debug output"
})

if (!$disable)
{
    Write-Info "Setting global state to debug output"
}
else 
{
    Write-Info "Setting global state to non-debug output"
}

SetDebuggingState $disable
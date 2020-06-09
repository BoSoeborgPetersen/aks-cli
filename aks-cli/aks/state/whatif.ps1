param([switch] $disable)

WriteAndSetUsage "aks state whatif" ([ordered]@{
    "[-disable]" = "Flag to disable WhatIf (Dry Run) execution"
})

if (!$disable)
{
    Write-Info "Setting global state to WhatIf (Dry Run) execution"
}
else 
{
    Write-Info "Setting global state to normal execution"
}

SetWhatIfState $disable
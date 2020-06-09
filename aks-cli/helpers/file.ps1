function SaveTempFile($arguments)
{
    $filepath = "~/$(New-Guid).json"
    $json = $arguments | ConvertTo-Json -Depth 10
    Write-Verbose $json
    $json | Out-File -FilePath $filepath
    return $filepath
}

function DeleteTempFile($filepath)
{
    Remove-Item $filepath
}
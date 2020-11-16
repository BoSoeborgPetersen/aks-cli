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

function SaveFile($content, $filePath)
{
    Write-Verbose "Writing file '$filePath'"
    $content | Out-File -FilePath $filepath
}

# function LoadFile($filepath)
# {
#     return Get-Content -Path $filepath
# }
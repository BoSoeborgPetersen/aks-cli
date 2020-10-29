param($name, $location)

WriteAndSetUsage ([ordered]@{
    "<name>" = "Name"
    "<location>" = AzureLocationDescription
})

AzCheckLocation $location

Write-Info "Checking Resource Group '$name' in Location '$location'"
AzCheckResourceGroup $name -l $location
Write-Info "Resource Group '$name' exists in Location '$location'"
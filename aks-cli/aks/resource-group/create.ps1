param ($name, $location)

AzCheckNotResourceGroup $name
AzCheckLocation $location

Write-Info "Creating resource group '$name' in location '$location'"

AzCommand "group create -g $name -l $location"
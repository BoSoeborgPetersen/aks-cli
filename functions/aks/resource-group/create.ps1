param ($name, $location)

CheckResourceGroupNotExists $name
CheckLocationExists $location

Write-Info "Creating resource group '$name' in location '$location'"

ExecuteCommand "az group create -g $name -l $location $debugString"
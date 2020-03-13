Write-Host $PSScriptRoot

Set-Location $PSScriptRoot
$location = Get-Location

docker pull bo0petersen/aks-cli:latest
$scriptsDirExist = Test-Path $location/scripts
if(!$scriptsDirExist)
{
    mkdir $location/scripts
}
$tempDirExist = Test-Path $location/temp
if(!$tempDirExist)
{
    mkdir $location/temp
}
docker run --entrypoint "pwsh" -v $location/scripts:/app/scripts -v $location/temp:/app/temp -v $location/functions:/app/functions -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f functions/init.ps1
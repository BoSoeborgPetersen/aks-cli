$location = $PSScriptRoot
Set-Location $location

docker pull bo0petersen/aks-cli:latest

if(!(Test-Path $location/scripts))
{
    mkdir $location/scripts
}

if(!(Test-Path $location/temp))
{
    mkdir $location/temp
}

docker run --entrypoint "pwsh" -v $location/scripts:/app/scripts -v $location/temp:/app/temp -v $location/functions:/app/functions -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f functions/init.ps1
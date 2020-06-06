$path = $PSScriptRoot
Set-Location $path

docker pull bo0petersen/aks-cli:latest

if(!(Test-Path $path/scripts))
{
    mkdir $path/scripts
}

if(!(Test-Path $path/temp))
{
    mkdir $path/temp
}

docker run -v $path/scripts:/app/scripts -v $path/temp:/app/temp -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f aks-cli/init.ps1
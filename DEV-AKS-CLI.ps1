$path = $PSScriptRoot
Set-Location $path

docker build . -t dev-aks-cli

if(!(Test-Path $path/scripts))
{
    mkdir $path/scripts
}

if(!(Test-Path $path/temp))
{
    mkdir $path/temp
}

docker run -v $path/scripts:/app/scripts -v $path/temp:/app/temp -v $path/aks-cli:/app/dev-aks-cli -it --rm dev-aks-cli:latest -NoExit -NoLogo -f dev-aks-cli/init.ps1
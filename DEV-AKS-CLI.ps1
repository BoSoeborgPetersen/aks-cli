Set-Location $PSScriptRoot

if(!(Test-Path scripts))
{
    mkdir scripts
}

if(!(Test-Path temp))
{
    mkdir temp
}

docker build . -t dev-aks-cli && docker run -v scripts:/app/scripts -v temp:/app/temp -v aks-cli:/app/dev-aks-cli -it --rm dev-aks-cli:latest
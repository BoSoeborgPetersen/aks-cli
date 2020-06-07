Set-Location $PSScriptRoot

if(!(Test-Path scripts))
{
    mkdir scripts
}

if(!(Test-Path temp))
{
    mkdir temp
}

docker pull bo0petersen/aks-cli:latest && docker run -v scripts:/app/scripts -v temp:/app/temp -it --rm bo0petersen/aks-cli:latest
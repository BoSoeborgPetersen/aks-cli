$path = $PSScriptRoot
Set-path $path

# TODO: Maybe add "git pull".
docker pull bo0petersen/aks-cli:latest

if(!(Test-Path $path/scripts))
{
    mkdir $path/scripts
}

if(!(Test-Path $path/temp))
{
    mkdir $path/temp
}

docker run --entrypoint "pwsh" -v $path/scripts:/app/scripts -v $path/temp:/app/temp -v $path/functions:/app/functions -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f functions/init.ps1
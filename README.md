# Introduction 
Microsoft Powershell docker image extended with Azure CLI (az) &amp; Kubernetes CLI (kubectl) &amp; Helm CLI (helm)

The container alone just provides the Azure CLI (az), Kubernetes CLI (kubectl) & Helm CLI (helm).
But if you map the funtions inside the container and run the init script, it will provide the AKS-CLI, which makes it a lot easier to work with Azure Kubernetes Service clusters.

# Getting Started
To just run the container do:
´´´
docker run -it --rm 3shape/aks-cli:latest
´´´

To run the container and start the AKS-CLI do:
´´´
docker run --entrypoint "pwsh" -v $location/scripts:/app/scripts -v $location/functions:/app/functions -it --rm 3shape/aks-cli:latest -NoExit -NoLogo -f functions/init.ps1
´´´

# Build and Test
Try the image on docker hub

# Contribute
Submit an issue or a pull request

<!-- If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore) -->


# Windows terminal
Add the below to your profiles.json to enable having secure shell as a hotkey in Windows Terminal (remember to modify the path for the location of the repository)
´´´
{
    "guid": "{87a5cd29-e315-4213-b18c-a9402b2f7208}",
    "startingDirectory": "C:/source/SecureDockerCli",
    "hidden": false,
    "name": "AKS-Cli",
    "commandline": "powershell.exe -noexit  \" & C:\\source\\SecureDockerCLI\\AKS-Cli.ps1\"",
    "icon": "C:\\source\\SecureDockerCLI\\Aks-cli.png"
}
´´´
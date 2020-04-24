# TODO: Rewrite

# Introduction 
Microsoft Powershell docker image extended with Azure CLI (az) &amp; Kubernetes CLI (kubectl) &amp; Helm CLI (helm) &amp; Wercher/Stern (stern)

The container alone just provides the Azure CLI (az), Kubernetes CLI (kubectl), Helm CLI (helm) & Wercher/Stern (stern).
But if you map the funtions inside the container and run the init script, it will provide the AKS-CLI, which makes it a lot easier to work with Azure Kubernetes Service clusters.

# AKS-CLI: Main Menu

      __       __   ___   _______
     /  \     |  | /  /  |  _____|
    /    \    |  |/  /   |  |____
   /  /\  \   |     |    |____   |
  /  ____  \  |  |\  \    ____|  |
 /__/    \__\ |__| \__\  |_______|

Welcome to the AKS (Azure Kubernetes Service) CLI (aks)!

Also available: Azure CLI (az), Kubernetes CLI (kubectl), Helm v2 & v3 CLI (helm & helm3), Wercher/Stern (stern)
Also: Azure DevOps CLI extension (az devops), Curl, Git, Nano, PS-Menu

Here are the commands:

    cert-manager         : Certificate Manager operations.
    create               : Create AKS cluster.
    credentials          : Get AKS cluster credentials.
    current              : Get current AKS cluster.
    delete               : Delete AKS cluster.
    describe             : Describe Kubernetes resources.
    devops               : Azure DevOps operations.
    edit                 : Edit Kubernetes resource.
    get                  : Get Kubernetes resources.
    insights             : AKS insights operations.
    logs                 : Get container logs.
    monitoring           : Prometheus and Grafana operations.
    nginx                : NGINX Ingress operations.
    node-autoscaler      : Setup automatic AKS VM Scale Set scaling (Node scaling).
    pod-autoscaler       : Setup automatic AKS deployment scaling (Pod scaling).
    pod-clean            : Get rid of all failed pods in all namespaces.
    pod-delete           : Delete deployment pods
    pod-size             : Get container disk space usage.
    registry             : Azure Container Registry operations.
    scale-nodes          : Scale AKS VM Scale Set (Node scaling).
    scale-pods           : Scale AKS deployment (Pod scaling).
    service-principal    : Azure Service Principal operations
    shell                : Open shell inside container.
    switch               : Switch Azure subscription/cluster.
    tiller               : Helm server side component.
    top                  : Show Kubernetes resource utilization.
    upgrade              : Upgrade AKS cluster.
    upgrades             : Get AKS cluster upgradable versions.
    version              : Get AKS cluster version.
    versions             : Get AKS versions.

General flags: -v (show executed queries/commands), -debug (show debug output), -whatif (dry run).

e.g. try 'aks cert-manager'

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
    "commandline": "powershell.exe -noexit  \" & <source_dir_path>/AKS-Cli.ps1\"",
    "icon": "<source_dir_path>/Aks-cli.png"
}
´´´
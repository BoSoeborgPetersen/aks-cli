# TODO: Rewrite

# Introduction 
Microsoft Powershell docker image extended with Azure CLI (az) &amp; Kubernetes CLI (kubectl) &amp; Helm CLI (helm) &amp; Wercher/Stern (stern)

The container alone just provides the Azure CLI (az), Kubernetes CLI (kubectl), Helm CLI (helm) & Wercher/Stern (stern).
But if you map the funtions inside the container and run the init script, it will provide the AKS-CLI, which makes it a lot easier to work with Azure Kubernetes Service clusters.

# AKS-CLI: Main Menu
```

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

    autoscaler           : Setup automatic pod or node scaling.
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
    pod                  : Kubernetes pod operations.
    registry             : Azure Container Registry operations.
    scale                : Scale operations.
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

e.g. try 'aks autoscaler'
```

# Getting Started
To just run the container do:

```docker run -it --rm bo0petersen/aks-cli:latest```

To run the container and start the AKS-CLI do:

```docker run -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f aks-cli/init.ps1```

To run the container and start the AKS-CLI with volumes mounted do:

```docker run -v $path/scripts:/app/scripts -v $path/temp:/app/temp -it --rm bo0petersen/aks-cli:latest -NoExit -NoLogo -f aks-cli/init.ps1```

# Build and Test
Try the image on docker hub

# Contribute
Submit an issue or a pull request

<!-- If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore) -->

# Windows terminal
Add the below to your settings.json under profiles to add AKS-CLI to Windows Terminal (remember to modify the path for the location of the repository)

```json
{
    "guid": "{636d6d48-1d06-40e6-9958-77569099d16c}",
    "name": "AKS-CLI",
    "startingDirectory": "<source_dir_path>",
    "commandline": "powershell.exe -noexit  \" & <source_dir_path>/AKS-Cli.ps1\"",
    "icon": "<source_dir_path>/Aks-cli.png",
    "backgroundImage": "<source_dir_path>/Aks-cli.png"
}
```
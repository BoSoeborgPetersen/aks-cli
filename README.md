# Azure Kubernetes Service CLI

Azure-CLI (az) docker image extended with AKS-CLI, PowerShell Core, Kubernetes-CLI, Helm-CLI & Wercher/Stern.

Goal: To make it a lot easier to work with Azure Kubernetes Service clusters.

An simple example is the "aks upgrades" command, which lists the available upgradable versions for the current AKS cluster.

By default the container launches the AKS-CLI, which after selecting the Azure subscription & AKS cluster, provides extended functionality for managing AKS clusters.

## Content

- AKS-CLI (aks)
- Azure-CLI (az)
  - Azure DevOps extension (az devops)
- PowerShell Core (pwsh)
  - PSMenu Module (Show-Menu)
  - PSBashCompletions Module (Register-BashArgumentCompleter)
- Kubernetes-CLI (kubectl)
  - Cert-Manager extension (kubectl cert-manager)
- Helm-CLI
  - Version 2 (helm)
  - Version 3 (helm3)
    - Stable repo (<https://kubernetes-charts.storage.googleapis.com>)
    - Cert-Manager repo (<https://charts.jetstack.io>)
    - 2to3 plugin (<https://github.com/helm/helm-2to3>)
- Wercher/Stern (stern)
- Nano
- Bash Completion for PowerShell, for each CLI

## Main Menu

```text
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
    current              : Get current AKS cluster.
    delete               : Delete AKS cluster.
    describe             : Describe Kubernetes resources.
    devops               : Azure DevOps operations.
    edit                 : Edit Kubernetes resource.
    get                  : Get Kubernetes resources.
    identity             : Azure Managed Identity operations
    insights             : AKS insights operations.
    keyvault             : Azure Key Vault operations.
    kured                : Kured (KUbernetes REboot Daemon) operations.
    logs                 : Get container logs.
    nginx                : Nginx operations.
    pod                  : Kubernetes pod operations.
    registry             : Azure Container Registry operations.
    resource-group       : Azure Resource Group operations.
    scale                : Scale operations.
    service-principal    : Azure Service Principal operations
    shell                : Open shell inside container.
    switch               : Switch Azure subscription / AKS cluster.
    tiller               : Tiller (Helm v2 server side component) operations.
    top                  : Show Kubernetes resource utilization.
    upgrade              : Upgrade AKS cluster.
    upgrades             : Get AKS cluster upgradable versions.
    version              : Get AKS cluster version.
    versions             : Get AKS versions.

General flags: -v (show executed queries/commands), -debug (show debug output), -whatif (dry run).

e.g. try 'aks autoscaler'
```

## Getting Started

Run AKS-CLI:

> docker run --rm -it bo0petersen/aks-cli

Run AKS-CLI, with volume mount:

```docker run --rm -it -v mapped:/app/mapped bo0petersen/aks-cli```

Ensure that the latest images is pulled & run AKS-CLI:

```docker pull bo0petersen/aks-cli && docker run --rm -it -v mapped:/app/mapped bo0petersen/aks-cli```

Or, with Docker v19.09:

```docker run --rm -it --pull=always -v mapped:/app/mapped bo0petersen/aks-cli```

## Windows terminal

Add the below to your settings.json under profiles to add AKS-CLI to Windows Terminal (remember to modify the path for the location of the repository)

Add to settings.json under profiles:

```json
{
  "guid": "{636d6d48-1d06-40e6-9958-77569099d16c}",
  "name": "AKS-CLI",
  "startingDirectory": "<start_dir_path>",
  "commandline": "pwsh -Command \"& { docker pull bo0petersen/aks-cli && docker run --rm -it -v mapped:/app/mapped bo0petersen/aks-cli }\"",
  "icon": "<icon_path>/Aks-cli.png",
  "backgroundImage": "<icon_path>/Aks-cli.png"
}
```

Or, with Docker v19.09:

```json
{
  "guid": "{636d6d48-1d06-40e6-9958-77569099d16c}",
  "name": "AKS-CLI",
  "startingDirectory": "<start_dir_path>",
  "commandline": "docker run --rm -it --pull=always -v mapped:/app/mapped bo0petersen/aks-cli",
  "icon": "<icon_path>/Aks-cli.png",
  "backgroundImage": "<icon_path>/Aks-cli.png"
}
```

NB: Remember to replace paths and download "Aks-cli.png".

## Build and Test

Clone git repository:

> git clone <https://github.com/BoSoeborgPetersen/azure-kubernetes-service-cli.git>

Create directories for volume mounting:

> mkdir mapped

Run AKS-CLI in development mode:

> docker build . -t dev-aks-cli
> docker run --rm -it -v scripts:/app/scripts -v temp:/app/temp -v aks-cli:/app/dev-aks-cli dev-aks-cli --entrypoint pwsh -NoExit -NoLogo -f dev-aks-cli/init.ps1

Run AKS-CLI in development mode, with Windows Terminal:

```json
{
  "guid": "{3cf0be50-3aa0-4f1d-b4f1-c6ccbe6b7ef3}",
  "name": "AKS-CLI (Development)",
  "startingDirectory": "<start_dir_path>",
  "commandline": "pwsh -Command \"& { docker build . -t dev-aks-cli && docker run --rm -it -v scripts:/app/scripts -v temp:/app/temp -v aks-cli:/app/dev-aks-cli dev-aks-cli --entrypoint pwsh -NoExit -NoLogo -f dev-aks-cli/init.ps1 }\"",
  "icon": "<icon_path>/Aks-cli.png",
  "backgroundImage": "<icon_path>/Aks-cli.png"
}
```

## Contribute

Submit an issue or a pull request

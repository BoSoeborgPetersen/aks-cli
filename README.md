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

    analytics            : Azure Monitor for containers - Monitor the performance of container workloads
    cert-manager         : Certificate Manager - Automatically provision and manage TLS certificates in Kubernetes.
    create               : Create AKS cluster.
    credentials          : Get AKS cluster credentials.
    current              : Get current AKS cluster.
    delete               : Delete AKS cluster.
    delete-pods          : Delete pods for deployment
    describe             : Describe details for Kubernetes resources.
    devops               : Azure DevOps operations.
    edit                 : Edit Kubernetes resource.
    get                  : Show Kubernetes resources.
    logs                 : Get Deployment logs.
    monitoring           : Monitoring with Prometheus and Grafana.
    nginx                : NGINX Ingress (Reverse Proxy Server) Controller for Kubernetes, which does SSL termination.
    node-autoscaler      : Scale AKS VMs automatically - Automatic node scaling.
    pod-autoscaler       : Scale AKS deployment automatically - Automatic pod scaling.
    pod-size             : Get Deployment Pod used disk space.
    registry             : Azure Container Registry operations.
    scale-nodes          : Scale AKS VMs - Manual node scaling.
    scale-pods           : Scale AKS deployment - Manual pod scaling.
    service-principal    : Azure Service Principal operations
    setup                : Create Kubernetes cluster, install add-ons and configure both.
    shell                : Open shell inside container pod.
    switch               : (Interactive) Change current Azure subscription, AKS cluster or AKS deployment.
    tiller               : Helm server side component (Tiller).
    top                  : Show resource utilization for Kubernetes resources.
    traffic-manager      : Azure Traffic Manager operations
    upgrade              : Upgrades AKS cluster.
    upgrades             : Get AKS cluster upgradable versions.
    version              : Get AKS cluster version.
    versions             : Get AKS versions.

e.g. try 'aks logs'

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
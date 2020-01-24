# Base image with PowerShell
FROM mcr.microsoft.com/powershell:debian-9

# Install Curl
RUN apt-get update && \
    apt-get install -y curl

# Install Azure-Cli (az)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
# Install DevOps extension for Azure Cli (az devops)
RUN az extension add --name azure-devops
 
# Install Kubernetes-Cli (kubectl)
RUN az aks install-cli

# Install Helm-Cli (helm)
RUN curl -LO https://git.io/get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    helm init --client-only && \
    helm repo update

# Install Helm-Cli version 3 (helm3)
RUN curl -LO https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz && \
    mkdir helm3 && \
    tar -xzf helm-v3.0.2-linux-amd64.tar.gz --directory helm3 && \
    ln -s /helm3/linux-amd64/helm /usr/bin/helm3 && \
    rm helm-v3.0.2-linux-amd64.tar.gz
    
# Install Nano
RUN apt-get install nano

# Install Powershell 'PS-Menu' module
RUN pwsh -c "Install-Module PS-Menu -Force"

WORKDIR /app
ENTRYPOINT ["pwsh"]

# Base image with PowerShell
FROM mcr.microsoft.com/powershell:debian-9

# Install Curl
RUN apt-get update && \
    apt-get install -y curl

# Install git
RUN apt-get -y update && \
    apt-get -y install git
    
# Install Nano
RUN apt-get install nano

# Install Helm-Cli (helm)
RUN curl -LO https://git.io/get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    helm init --client-only && \
    helm repo update

# Install Helm-Cli version 3 (helm3)
# Install 2to3 plugin for Helm-Cli version 3 (helm3 2to3)
RUN curl -LO https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz && \
    mkdir helm3 && \
    tar -xzf helm-v3.0.3-linux-amd64.tar.gz --directory helm3 && \
    ln -s /helm3/linux-amd64/helm /usr/bin/helm3 && \
    rm helm-v3.0.3-linux-amd64.tar.gz && \
    helm3 plugin install https://github.com/helm/helm-2to3

# Install Azure-Cli (az)
# Install DevOps extension for Azure Cli (az devops)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    az extension add --name azure-devops
 
# Install Kubernetes-Cli (kubectl)
RUN az aks install-cli

# Install Powershell 'PS-Menu' module
RUN pwsh -c "Install-Module PS-Menu -Force"

# Slim down image
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

WORKDIR /app
ENTRYPOINT ["pwsh"]

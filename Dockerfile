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
    
# Install Nano
RUN apt-get install nano

WORKDIR /app
ENTRYPOINT ["pwsh"]

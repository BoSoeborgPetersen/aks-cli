# Base image with Azure-Cli (675 MB) 
FROM mcr.microsoft.com/azure-cli:latest 
 
# Install DevOps extension for Azure Cli (az devops) (17 MB) 
RUN az extension add --name azure-devops 
 
# Install PowerShell Core (134 MB) 
ENV POWERSHELL_VERSION=7.0.3 
RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl && \ 
    apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust && \ 
    curl -L https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz && \ 
    mkdir -p /opt/microsoft/powershell/7 && \ 
    tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \ 
    chmod +x /opt/microsoft/powershell/7/pwsh && \ 
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \ 
    rm /tmp/powershell.tar.gz 
 
# Install Powershell modules (0 MB) 
RUN pwsh -c "Install-Module PSMenu -Force" && \ 
    pwsh -c "Install-Module -Name PSBashCompletions -Scope CurrentUser -Force" 
 
# Install Nano (6 MB) 
RUN apk add nano --no-cache 
  
# Install Kubernetes-Cli (kubectl) (45 MB) + (plugin: 40 MB) 
ENV KUBECTL_CERT_MANAGER_VERSION=1.0.2
RUN az aks install-cli --only-show-errors && \ 
    curl -L https://github.com/jetstack/cert-manager/releases/download/v${KUBECTL_CERT_MANAGER_VERSION}/kubectl-cert_manager-linux-amd64.tar.gz -o /tmp/kubectl-cert-manager.tar.gz && \ 
    tar zxf /tmp/kubectl-cert-manager.tar.gz && \ 
    mv kubectl-cert_manager /usr/local/bin && \ 
    rm /tmp/kubectl-cert-manager.tar.gz 
 
# Install Wercker\Stern (21 MB) 
ENV STERN_VERSION=1.11.0 
RUN curl -L -o /usr/local/bin/stern https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \ 
    chmod +x /usr/local/bin/stern 
 
# Install Helm-Cli version 2 (helm2) (90 MB) 
ENV HELM_VERSION=2.16.12
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \ 
    mkdir helm2 && \ 
    tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz --directory helm2 && \ 
    ln -s /helm2/linux-amd64/helm /usr/bin/helm2 && \ 
    rm helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Install Helm-Cli version 3 (helm) (~90 MB) 
# Install 2to3 plugin for Helm-Cli version 3 (helm 2to3)
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && \  
    helm repo add stable https://kubernetes-charts.storage.googleapis.com && \  
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \  
    helm repo add jetstack https://charts.jetstack.io && \  
    helm repo add kured https://weaveworks.github.io/kured && \  
    helm repo update && \ 
    helm plugin install https://github.com/helm/helm-2to3  
 
# Install Bash completion 
ENV COMPLETIONS=/usr/share/bash-completion/completions 
RUN apk add bash-completion && \ 
    printf "\nsource /etc/profile.d/bash_completion.sh" >> ~/.bashrc && \ 
    kubectl completion bash > $COMPLETIONS/kubectl.bash && \ 
    stern --completion bash > $COMPLETIONS/stern.bash && \ 
    helm2 completion bash > $COMPLETIONS/helm2.bash && \ 
    helm completion bash > $COMPLETIONS/helm.bash 
 
WORKDIR /app 
COPY aks-cli aks-cli 
 
ENTRYPOINT [ "pwsh", "-NoExit", "-NoLogo", "-f", "aks-cli/init.ps1" ]
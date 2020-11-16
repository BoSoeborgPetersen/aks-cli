# Base image with Azure-Cli (712 MB)
FROM mcr.microsoft.com/azure-cli:latest

# Install DevOps extension for Azure Cli (az devops) (17 MB)
RUN az extension add --name azure-devops

# Install PowerShell Core (134 MB)
ENV POWERSHELL_VERSION=7.1.0
RUN apk add ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl lttng-ust -X https://dl-cdn.alpinelinux.org/alpine/edge/main --no-cache && \
    curl -sSLo /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-alpine-x64.tar.gz && \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar -zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    rm /tmp/powershell.tar.gz

# Install Powershell modules (0 MB)
RUN pwsh -c "Install-Module PSMenu -Force && Install-Module PSBashCompletions -Scope CurrentUser -Force"

# Install Nano (6 MB)
RUN apk add nano --no-cache

# Install Kubernetes-Cli (kubectl) (45 MB) + (plugin: 50 MB)
ENV KUBECTL_CERT_MANAGER_VERSION=1.1.0
RUN az aks install-cli --only-show-errors && \
    curl -sSLo /tmp/kubectl-cert-manager.tar.gz https://github.com/jetstack/cert-manager/releases/download/v${KUBECTL_CERT_MANAGER_VERSION}/kubectl-cert_manager-linux-amd64.tar.gz && \
    tar -zxf /tmp/kubectl-cert-manager.tar.gz kubectl-cert_manager -C /usr/local/bin && \
    rm /tmp/kubectl-cert-manager.tar.gz

# Install Wercker\Stern (22 MB)
ENV STERN_VERSION=1.11.0
RUN curl -sSLo /usr/local/bin/stern https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && \
    chmod +x /usr/local/bin/stern

# Install ahmetb/kubectx (28 MB)
ENV KUBECTX_VERSION=0.9.1
RUN curl -sSLo /tmp/kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz && \
    tar -zxf /tmp/kubectx.tar.gz kubectx -C /usr/local/bin && \
    rm /tmp/kubectx.tar.gz

# Install ahmetb/kubectx/kubens (28 MB)
ENV KUBENS_VERSION=0.9.1
RUN curl -sSLo /tmp/kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v${KUBENS_VERSION}/kubens_v${KUBENS_VERSION}_linux_x86_64.tar.gz && \
    tar -zxf /tmp/kubens.tar.gz kubens -C /usr/local/bin && \
    rm /tmp/kubens.tar.gz

# Install maorfr/helm-backup (??? MB)
ENV HELM_BACKUP_VERSION=0.1.2
RUN curl -sSLo /tmp/helm-backup.tar.gz https://github.com/maorfr/helm-backup/releases/download/${HELM_BACKUP_VERSION}/helm-backup-linux-${HELM_BACKUP_VERSION}.tgz && \
    tar -zxf /tmp/helm-backup.tar.gz backup -C /usr/local/bin && \
    rm /tmp/helm-backup.tar.gz

# Install Helm-Cli version 2 (helm2) (40 MB)
ENV HELM_VERSION=2.17.0
RUN curl -sSLo /tmp/helm2.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxf /tmp/helm2.tar.gz linux-amd64/helm && \
    mv /linux-amd64/helm /usr/local/bin/helm2 && \
    rm /tmp/helm2.tar.gz

# Install Helm-Cli version 3 (helm) (~90 MB)
ENV HELM_VERSION=3.4.1
RUN curl -sSLo /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxf /tmp/helm.tar.gz linux-amd64/helm && \
    mv /linux-amd64/helm /usr/local/bin/helm && \
    rm /tmp/helm.tar.gz

# Install 2to3 plugin for Helm-Cli version 3 (helm 2to3)
RUN helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
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
    curl -sSLo $COMPLETIONS/kubectx.bash https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.bash && \
    curl -sSLo $COMPLETIONS/kubens.bash https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.bash && \
    helm2 completion bash > $COMPLETIONS/helm2.bash && \
    helm completion bash > $COMPLETIONS/helm.bash

WORKDIR /app
COPY aks-cli aks-cli

ENTRYPOINT [ "pwsh", "-NoExit", "-NoLogo", "-f", "aks-cli/init.ps1" ]
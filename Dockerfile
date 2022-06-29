# Base image with Azure-Cli (az)
FROM mcr.microsoft.com/azure-cli:2.37.0

# Install Bicep
RUN az bicep install

# Install DevOps extension for Azure Cli (az devops)
RUN az extension add --name azure-devops

# Install PowerShell Core (pwsh)
RUN apk add ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl lttng-ust -X https://dl-cdn.alpinelinux.org/alpine/edge/main --no-cache && \
    mkdir -p /opt/microsoft/powershell/7 && \
    curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*powershell-[^-]+-linux-alpine-x64[^\"]*' | xargs curl -sSL | tar -zx -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh && \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh 

# Install Powershell modules
RUN pwsh -c "Install-Module PSMenu -Force" && \
    pwsh -c "Install-Module PSBashCompletions -Force" && \
    pwsh -c "Install-Module GetPassword -Force" && \
    pwsh -c "Install-Module PSReadLine -Force"

# Install Nano (nano)
RUN apk add nano --no-cache

# Install Kubernetes-Cli (kubectl, kubectl cert-manager)
RUN az aks install-cli --only-show-errors && \
    curl -sSL https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz | tar -zx ./kubectl-cert_manager -C /usr/local/bin

# Install Wercker\Stern (stern)
RUN curl -sSLo /usr/local/bin/stern https://github.com/wercker/stern/releases/latest/download/stern_linux_amd64 && \
    chmod +x /usr/local/bin/stern

# Install ahmetb/kubectx (kubectx)
RUN curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | jq -r '.assets[] | select(.name|test("kubectx_[^_]+_linux_x86_64.tar.gz")) | .browser_download_url' | xargs curl -sSL | tar -zx kubectx -C /usr/local/bin

# Install ahmetb/kubectx/kubens (kubens)
RUN curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*kubens_[^_]+_linux_x86_64[^\"]*' | xargs curl -sSL | tar -zx kubens -C /usr/local/bin

# Install Helm-Cli (helm)
RUN curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r .tag_name | xargs -I {} curl -sSL https://get.helm.sh/helm-{}-linux-amd64.tar.gz | tar -zx linux-amd64/helm && \
    mv /linux-amd64/helm /usr/local/bin/helm

# Setup Helm
RUN helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && \
    helm repo add jetstack https://charts.jetstack.io && \
    helm repo add kured https://weaveworks.github.io/kured && \
    helm repo add cowboysysop https://cowboysysop.github.io/charts && \
    helm repo add kedacore https://kedacore.github.io/charts && \
    helm repo add prometheus https://prometheus-community.github.io/helm-charts && \
    helm repo add grafana https://grafana.github.io/helm-charts && \
    helm repo update && \
    helm plugin install https://github.com/fabmation-gmbh/helm-whatup && \
    rm /tmp/helm-whatup.tgz && \
    rm -r /tmp/helm-whatup

# Install derailed/k9s (k9s)
RUN curl -sSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_x86_64.tar.gz | tar -zx k9s -C /usr/local/bin

# Install derailed/popeye (popeye)
RUN curl -sSL https://github.com/derailed/popeye/releases/latest/download/popeye_Linux_x86_64.tar.gz | tar -zx popeye -C /usr/local/bin

# Install Shopify/kubeaudit (kubeaudit)
RUN curl -s https://api.github.com/repos/Shopify/kubeaudit/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*kubeaudit_[^_]+_linux_amd64[^\"]*' | xargs curl -sSL | tar -zx kubeaudit -C /usr/local/bin

# Install Kubescape
RUN curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash

# Install kvaps/kubectl-node-shell (kubectl node-shell)
RUN curl -Lo /usr/local/bin/kubectl-node_shell https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell && \
    chmod +x /usr/local/bin/kubectl-node_shell

# Install pulumi/kubespy (kubespy)
RUN curl -s https://api.github.com/repos/pulumi/kubespy/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*kubespy-[^-]+-linux-amd64[^\"]*' | xargs curl -sSL | tar -zx kubespy -C /usr/local/bin

# Install astefanutti/kubebox (kubebox)
RUN curl -Lo /usr/local/bin/kubebox https://github.com/astefanutti/kubebox/releases/latest/download/kubebox-linux && \
    chmod +x /usr/local/bin/kubebox

# Install c-bata/kube-prompt (kube-prompt)
RUN curl -s https://api.github.com/repos/c-bata/kube-prompt/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*kube-prompt_[^_]+_linux_amd64[^\"]*' | xargs curl -sSLo /tmp/kube-prompt.zip && \ 
    unzip /tmp/kube-prompt.zip -d /usr/local/bin && \ 
    rm /tmp/kube-prompt.zip 

# # Install Kui (kubectl kui)
# RUN curl -s https://api.github.com/repos/kubernetes-sigs/kui/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*Kui-linux-x64.zip[^\"]*' | xargs curl -sSLo /tmp/kui.zip && \ 
#     unzip /tmp/kui.zip -d /usr/local/bin && \ 
#     rm /tmp/kui.zip

# Install Linkerd
RUN curl -fsL https://run.linkerd.io/install | sh && \
    ln -s /root/.linkerd2/bin/linkerd /usr/bin/linkerd

# Install Istioctl
RUN curl -s https://api.github.com/repos/istio/istio/releases/latest | grep -E 'browser_download_url' | grep -Eo '[^\"]*istio-[^-]+-linux-amd64[^\"]*' | xargs curl -sSLo /tmp/istio.tar.gz && \
    tar -ztf istio.tar.gz | grep bin/istioctl | xargs tar -zxf /tmp/istio.tar.gz --strip-components=2 -C /usr/local/bin && \
    rm /tmp/istio.tar.gz

# Install Terminal-Icons (required by Oh My Posh)
RUN mkdir -p ~/.local/share/fonts && \
    cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf && \
    pwsh -c "Install-Module -Name Terminal-Icons -Repository PSGallery -Force"

# Oh My Posh # TODO: Move OMP file and put other oh my posh stuff in powershell profile
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh && \ 
    chmod +x /usr/local/bin/oh-my-posh && \ 
    mkdir /root/.config/powershell
COPY aks-cli.omp.json /root/.config/powershell/aks-cli.omp.json

# TODO: https://github.com/boxboat/aks-health-check

# Install Bash completion
ENV COMPLETIONS=/usr/share/bash-completion/completions
RUN apk add bash-completion && \
    printf "\nsource /etc/profile.d/bash_completion.sh" >> ~/.bashrc && \
    kubectl completion bash > $COMPLETIONS/kubectl.bash && \
    stern --completion bash > $COMPLETIONS/stern.bash && \
    curl -sSLo $COMPLETIONS/kubectx.bash https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.bash && \
    curl -sSLo $COMPLETIONS/kubens.bash https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.bash && \
    helm completion bash > $COMPLETIONS/helm.bash

WORKDIR /app
COPY aks-cli aks-cli
# Copy PowerShell profile
COPY Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

ENTRYPOINT [ "pwsh", "-NoExit", "-NoLogo", "-f", "aks-cli/init.ps1" ]
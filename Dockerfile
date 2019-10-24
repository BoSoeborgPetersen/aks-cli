# Base image with PowerShell
FROM mcr.microsoft.com/powershell:debian-9

# Install Curl
RUN apt-get update
RUN apt-get install -y curl

# Install Azure-Cli (az)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
 
# Install Kubernetes-Cli (kubectl)
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# Install Helm-Cli (helm)
RUN curl -LO https://git.io/get_helm.sh
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

WORKDIR /app
ENTRYPOINT ["pwsh"]
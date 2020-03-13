param($type, $name)

# $usage = Write-Usage "aks nginx edit-configmap [deployment name]"

# VerifyCurrentCluster $usage

# $nginxDeploymentName = GetNginxDeploymentName $deploymentName

# Write-Info ("Edit configmap for Nginx-Ingress on current AKS cluster '$($selectedCluster.Name)'")

# TODO: Refactor.
ExecuteCommand ("bash -c `"KUBE_EDITOR=```"nano```" kubectl edit $type $name`"")
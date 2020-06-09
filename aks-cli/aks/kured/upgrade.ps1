WriteAndSetUsage "aks kured upgrade"

CheckCurrentCluster
$deployment = KuredDeploymentName

Write-Info "Upgrading Kured"

HelmCommand "upgrade $deployment kured/kured --reuse-values" -n $deployment
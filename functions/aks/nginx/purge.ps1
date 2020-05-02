# TODO: Move into uninstall.ps1 as -purge flag.
WriteAndSetUsage "aks nginx purge [deployment name]"

$namespace = "ingress"
CheckCurrentCluster

Write-Info "Remove Nginx namespace"

if (AreYouSure)
{
    KubectlCommand "delete ns $namespace"
}
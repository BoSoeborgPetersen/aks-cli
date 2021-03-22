WriteAndSetUsage

Write-Info "Replacing Keda (Kubernetes Event-driven Autoscaling)"

if (AreYouSure)
{
    AksCommand keda uninstall -yes -skipNamespace
    AksCommand keda install -skipNamespace
}
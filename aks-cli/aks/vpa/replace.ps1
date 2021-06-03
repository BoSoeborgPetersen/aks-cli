WriteAndSetUsage

Write-Info "Replacing Vertical Pod Autoscaler"

if (AreYouSure)
{
    AksCommand vpa uninstall -yes -skipNamespace
    AksCommand vpa install -skipNamespace
}
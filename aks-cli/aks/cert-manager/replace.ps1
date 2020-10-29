WriteAndSetUsage

Write-Info "Replacing Cert-Manager"

if (AreYouSure)
{
    AksCommand cert-manager uninstall -yes
    AksCommand cert-manager install -skipNamespace
}
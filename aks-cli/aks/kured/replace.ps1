WriteAndSetUsage "aks kured replace"

Write-Info "Replacing Kured (KUbernetes REboot Daemon)"

if (AreYouSure)
{
    AksCommand kured uninstall -yes -skipNamespace
    AksCommand kured install -skipNamespace
}
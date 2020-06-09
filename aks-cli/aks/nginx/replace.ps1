WriteAndSetUsage "aks nginx replace"

Write-Info "Replacing Nginx"

if (AreYouSure)
{
    AksCommand nginx uninstall -yes
    AksCommand nginx install
}
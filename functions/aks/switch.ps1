param($command)

if ($command -eq "")
{
    ExecuteCommand "aks switch account"
}
else
{
    SubMenu @{
        "account" = "(Interactive) Change current Azure subscription."
        "cluster" = "(Interactive) Change current AKS cluster."
    }
}
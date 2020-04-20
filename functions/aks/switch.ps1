param($command)

if (!$command)
{
    ExecuteCommand "aks switch subscription"
}
else
{
    SubMenu @{
        "subscription" = "Change current Azure subscription."
        "cluster" = "Change current AKS cluster."
    }
}
param($subCommand)

if ($subCommand -eq "")
{
    ExecuteCommand "aks switch account"
}
else
{
    $subCommands=@{
        "account" = "(Interactive) Change current Azure subscription.";
        "cluster" = "(Interactive) Change current AKS cluster.";
    }
    
    SubMenu $PSScriptRoot $command $subCommand $subCommands
}
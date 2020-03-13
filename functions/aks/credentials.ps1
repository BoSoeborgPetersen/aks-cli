param($subCommand)

$subCommands=@{
    "get" = "Get credentials.";
    "get-clean" = "Clear credentials and get new ones.";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands
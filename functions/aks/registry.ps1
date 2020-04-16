param($subCommand)

$subCommands=@{
    "migrate" = "Move images in repository in Azure Container Registry to another repository possible in another registry."
}

SubMenu $PSScriptRoot $command $subCommand $subCommands
param($subCommand)

$subCommands=@{
    "deploy" = "Run Azure DevOps pipeline, to deploy application.";
    # "replace" = "Replace Azure DevOps pipeline.";
    # "delete" = "Delete Azure DevOps pipeline.";
}

SubMenu $PSScriptRoot $command $subCommand $subCommands
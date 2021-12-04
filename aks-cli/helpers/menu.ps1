function Logo
{
    Write-Host ''
    Write-Host '      __       __   ___   _______  '
    Write-Host '     /  \     |  | /  /  |  _____| '
    Write-Host '    /    \    |  |/  /   |  |____  '
    Write-Host '   /  /\  \   |     |    |____   | '
    Write-Host '  /  ____  \  |  |\  \    ____|  | '
    Write-Host ' /__/    \__\ |__| \__\  |_______| '
    Write-Host ''
}

function Welcome
{
    Write-Host (ConditionalOperator $GlobalIsDevelopment " --- DEVELOPMENT EDITION --- `n`n") -NoNewline
    Write-Host 'Welcome to the AKS (Azure Kubernetes Service) CLI (aks)!'
    Write-Host ''
    Write-Host 'Also available: Azure CLI (az), Kubernetes CLI (kubectl), Helm CLI (helm),'
    Write-Host '  Wercher/Stern (stern), Kubectx, Kubens, K9s, Popeye, KubeAudit, Kubescape, NodeShell, Kubespy, Kubebox, Kube-prompt'
    Write-Host 'Also: Azure DevOps CLI extension (az devops), Curl, Git, Nano, PS-Menu'
}

function ShowCommandBreadcrumbs($commandPrefix)
{
    Write-Host "$commandPrefix <command>"
}

function ShowCommands($commands)
{
    Write-Host ''
    $maxSubCommandLength = ($commands.Keys | Measure-Object -Maximum -Property Length).Maximum

    ForEach ($key in ($commands.Keys | Sort-Object)) {
        Write-Host ("    $($key.PadRight($maxSubCommandLength + 4)): $($commands["$key"])")
    }

    Write-Host ''
}

function ShowGeneralFlags
{
    Write-Host 'General flags: -h (help), -v (show executed queries/commands), -debug (show debug output), -whatif (dry run).'
    Write-Host ''
}

function ShowExample($commands)
{
    $commandToShowAsExample = $commands.keys | Sort-Object | Select-Object -first 1

    if ($commandToShowAsExample.Contains('|'))
    {
        $commandToShowAsExample = $commandToShowAsExample.Split('|')[0]
    }

    Write-Host ("e.g. try '$commandPrefix $commandToShowAsExample'")
}

function ShowMenu($commandPrefix, $commands)
{
    Logo

    if ($commandPrefix -eq "aks")
    {
        Welcome
    }
    else
    {
        ShowCommandBreadcrumbs $commandPrefix
    }

    Write-Host ''
    Write-Host 'Here are the commands:'
    ShowCommands $commands
    ShowGeneralFlags
    ShowExample $commands
    Write-Host ''
}

function ShowSubMenu($commands)
{
    ShowMenu "aks $($params[0])" $commands
}

function CheckCommand($commandPrefix, $command, $commands, $noScriptFile, $multiKey)
{
    if ($command) 
    {
        $commandExists = $commands.Contains($command)

        if (!$commandExists -and $multiKey)
        {
            foreach ($possibleCommand in $commands.Keys)
            {
                foreach ($multiKeyPart in ($possibleCommand.Split('|')))
                {
                    if ($multiKeyPart -eq $command)
                    {
                        $commandExists = $true
                    }
                }
            }
        }

        if ($commandExists) 
        {
            if ($noScriptfile)
            {
                return
            }

            $commandPrefixPath = $commandPrefix.Replace(' ', '/')
            $path = "$GlobalRoot/$commandPrefixPath/$command.ps1"
            $scriptExists = [System.IO.File]::Exists($path)

            if ($scriptExists) 
            {
                SetCurrentCommandText $commands["$command"]
                SetCurrentUsage "$commandPrefix $command"

                return $path
            }
            else
            {
                Write-Error "Script for command does not exist: $path"
            }
        }
        else
        {
            Write-Error "Invalid command '$command'"
        }
    }

    ShowMenu $commandPrefix $commands
    exit
}

function CheckNoScriptSubCommand($command, $commands)
{
    $multiKey = $commands.Keys.Where({ $_ -like '*|*' }, 'First').Count -gt 0
    CheckCommand "aks $($params[0])" $command $commands $true $multiKey
}

function CheckKubectlCommand($command, $operation, [switch] $includeAll)
{
    $allCommand = @{
        "all" = "$operation standard Kubernetes resources"
    }

    $nonAllCommands = @{
        "cert|certificate" = "$operation Certificates"
        "challenge" = "$operation Challenges"
        "cm|configmap" = "$operation ConfigMap"
        "ds|daemonset" = "$operation DaemonSet"
        "deploy|deployment" = "$operation Deployments"
        "ev|event" = "$operation Event"
        "hpa|horizontalpodautoscaler" = "$operation Horizontal Pod Autoscalers"
        "ing|ingress" = "$operation Ingress"
        "issuer" = "$operation Issuers"
        "ns|namespace" = "$operation Namespace"
        "no|node" = "$operation Nodes"
        "order" = "$operation Orders"
        "po|pod" = "$operation Pods"
        "rs|replicaset" = "$operation Replica Sets"
        "secret" = "$operation Secrets"
        "svc|service" = "$operation Services"
    }

    if ($includeAll)
    {
        $commands = $allCommand + $nonAllCommands
    }
    else
    {
        $commands = $nonAllCommands
    }

    CheckNoScriptSubCommand $command $commands
}

function MainMenu($commands)
{
    $path = CheckCommand "aks" $params[0] $commands
    
    Invoke-Expression "$path $(QuoteParamsWithSpaces($params | Select-Object -Skip 1))"
}

function SubMenu($commands)
{
    $path = CheckCommand "aks $($params[0])" $params[1] $commands

    Invoke-Expression "$path $(QuoteParamsWithSpaces($params | Select-Object -Skip 2))"
}

function SubSubMenu($commands)
{
    $path = CheckCommand "aks $($params[0]) $($params[1])" $params[2] $commands

    Invoke-Expression "$path $(QuoteParamsWithSpaces($params | Select-Object -Skip 3))"
}

function QuoteParamsWithSpaces($params)
{
    if ($params -is [array])
    {
        for ($i=0; $i -lt $params.length; $i++)
        {
            if ($params[$i] -match " ")
            {
                $params[$i] = (('"' + $params[$i] +'"'))
            }
        }
    }
    else 
    {
        if ($params -match " ")
        {
            $params = (('"' + $params +'"'))
        }
    }
    return $params
}

function AreYouSure
{
    Write-Host ''
    $esc = "$([char]27)"
    $red = "$esc[31m"
    $question = $red + "Are you sure you want to proceed?" 
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice("", $question, $choices, 1)
    Write-Host ''

    return $decision -eq 0
}

function WantToContinue($question)
{
    Write-Host ''
    $esc = "$([char]27)"
    $red = "$esc[31m"
    $question = $red + "$question, proceed?" 
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice("", $question, $choices, 1)
    Write-Host ''

    if ($decision -ne 0)
    {
        exit
    }
}
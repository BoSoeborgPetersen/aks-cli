WriteAndSetUsage "aks devops pipeline deploy"

# TODO: Rewrite
az devops configure --defaults organization=https://dev.azure.com/3Shape/
# az pipelines run --name 'MasterData - PreRelease' --project Communicate
$id = az pipelines show --name 'MasterData - PreRelease' --query id --project Communicate
az pipelines runs list --project Communicate
az pipelines runs show --id $id --project Communicate

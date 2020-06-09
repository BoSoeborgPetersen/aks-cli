function AzDevOpsCheck($type, $name, $namespace, [switch] $exit)
{
    $check = AzDevOpsCommand "$type list" -q "[?name=='$name-$namespace'].name" -o tsv

    if (!$check) {
        Write-Error "Resource '$name' of type '$type' does not exist" -n $namespace
    }

    if ($exit)
    {
        exit
    }
}

function AzDevOpsInvokeCheck($area, $resource, $parameters, $query, [switch] $exit)
{
    $check = AzDevOpsInvokeQuery -a $area -r $resource -p $parameters -q $query -o tsv

    if (!$check) {
        Write-Error "Resource does not exist"
    }

    if ($exit)
    {
        exit
    }
}

function AzDevOpsCommand($command, $query, $output)
{
    AzCommand "devops $command" -q $query -o $output
}

function AzDevOpsQuery($command, $query, $subscription, $output)
{
    return AzQuery "devops $command" -q $query -s $subscription -o $output
}

function AzDevOpsInvokeCommand($area, $resource, $parameters, $methodHttp, $filepath, $query, $output)
{
    $filepathString = ConditionalOperator $filepath " --in-file $filepath"
    $project = DevOpsProjectName
    AzCommand "devops invoke --area $area --resource $resource --route-parameters project=$project $parameters --http-method $methodHttp --api-version 6.0-preview $filepathString" -q $query -o $output
}

function AzDevOpsInvokeQuery($area, $resource, $parameters, $query, $output)
{
    $project = DevOpsProjectName
    AzQuery "devops invoke --area $area --resource $resource --route-parameters project=$project --query-parameters $parameters --http-method GET --api-version 6.0-preview" -q $query -o $output
}

function AzDevOpsEnvironmentId($name)
{
    return AzDevOpsInvokeQuery -a environments -r environments -q "value[?name=='$name'].id" -o tsv
}

function AzDevOpsResourceId($name)
{
    return AzDevOpsInvokeQuery -a environments -r kubernetes -q "value[?name=='$name'].id" -o tsv
}
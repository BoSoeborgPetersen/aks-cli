# TODO: Include preview versions with prefix "(Preview) "
param($location)

$usage = Write-Usage "aks versions [location]"

VerifyCurrentClusterOrVariable $usage $location "<location>"

if ($location) {
    Write-Info "Available AKS versions for location '$location'"
}
elseif ($selectedCluster) {
    $location = $selectedCluster.Location
    Write-Info ("Available AKS versions for location '$location', taken from current AKS cluster '$($selectedCluster.Name)'")
}

ExecuteQuery "az aks get-versions -l $location --query 'orchestrators[?!isPreview].orchestratorVersion | sort(@)' -o tsv $debugString"

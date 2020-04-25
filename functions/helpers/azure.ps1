function CheckLocationExists($location)
{
    $check = ExecuteQuery "az account list-locations --query `"[?name=='$location'].name`" -o tsv"
    Check $check "Location '$location' does not exist"
}

function CheckVersionExists($version, $preview)
{
    CheckVersion $version

    $previewString = ConditionalOperator (!$preview) "!isPreview &&"
    $versionCheck = ExecuteQuery "az aks get-upgrades -n $($GlobalCurrentCluster.Name) -g $($GlobalCurrentCluster.ResourceGroup) --query `"controlPlaneProfile.upgrades[?$previewString kubernetesVersion=='$version'].kubernetesVersion`" -o tsv"
    Check $versionCheck "Version '$version' does not exist"
}
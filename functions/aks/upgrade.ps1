# TODO: Add parameter to use newest preview version 'usePreviewVersion'.
param($version)

$usage = Write-Usage "aks upgrade <version>"

VerifyCurrentCluster $usage

if ($version) 
{
    Write-Info ("Upgrading current cluster '$($selectedCluster.Name)' to version '$version'")
}
else
{
    $version = ExecuteQuery ("az aks get-upgrades -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --query 'controlPlaneProfile.upgrades[?!isPreview].kubernetesVersion | sort(@) | [-1]' -o tsv $debugString")

    
    Write-Info ("Upgrading current cluster '$($selectedCluster.Name)' to version '$version', which is the newest upgradable version for the current AKS cluster")
}

ExecuteCommand ("az aks upgrade -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) -k $version $debugString")
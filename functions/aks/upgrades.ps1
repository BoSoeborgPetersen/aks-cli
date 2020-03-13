# TODO: Include preview versions with prefix "(Preview) "
$usage = Write-Usage "aks upgrades"

VerifyCurrentCluster $usage

Write-Info ("Current AKS cluster '$($selectedCluster.Name)' upgradable versions")

ExecuteQuery ("az aks get-upgrades -n $($selectedCluster.Name) -g $($selectedCluster.ResourceGroup) --query 'controlPlaneProfile.upgrades[?!isPreview].kubernetesVersion | sort(@)' -o tsv $debugString")
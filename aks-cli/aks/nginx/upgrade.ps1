param($prefix, $configPrefix, $ip, [switch] $oldDnsNamingConvention, [switch] $skip)

WriteAndSetUsage ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
    "[config prefix]" = "AKS-CLI config file name prefix"
    "[oldDnsNamingConvention]" = "Add '-aks' to dns name"
    "[ip]" = "Azure Public IP to use"
})

if (!$ip)
{
    $svc = "nginx-ingress-ingress-nginx-controller"
    $svc = ConditionalOperator $prefix "$prefix-$svc" "$svc"
    $ip = KubectlQuery "get svc $svc" -n ingress -j '{.spec.loadBalancerIP}'
}

$prefixString = ConditionalOperator $prefix "-prefix '$prefix'"
$configPrefixString = ConditionalOperator $configPrefix "-configPrefix '$configPrefix'"
$ipString = ConditionalOperator $ip "-ip '$ip'"
$oldDnsNamingConventionString = ConditionalOperator $oldDnsNamingConvention "-oldDnsNamingConvention"
$skipString = ConditionalOperator $skip "-skip"

AksCommand nginx install $prefixString $configPrefixString $ipString $oldDnsNamingConventionString $skipString -upgrade
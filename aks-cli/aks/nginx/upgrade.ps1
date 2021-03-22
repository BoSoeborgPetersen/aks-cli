param($prefix, $configPrefix) #, $ip, [switch] $oldDnsNamingConvention, [switch] $skip)

WriteAndSetUsage ([ordered]@{
    "[prefix]" = "Kubernetes deployment name prefix"
    "[config prefix]" = "AKS-CLI config file name prefix"
})

AksCommand nginx install $prefix $configPrefix -upgrade
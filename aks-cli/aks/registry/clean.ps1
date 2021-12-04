param($registry)

WriteAndSetUsage ([ordered]@{
    "[registry]" = "Azure Container Registry"
})

Write-Info "Delete pre-release images that are older than 1 month in registry '$registry'"

if (AreYouSure)
{
    $repositories = AzQuery "acr repository list -n $registry" -o tsv

    foreach ($repository in $repositories)
    {
        $tags = AzQuery "acr repository show-tags -n $registry --repository $repository" -o tsv

        foreach ($tag in $tags)
        {
            $currentMonthString = (Get-Date).ToString("yyyyMM")
            $lastMonthString = (Get-Date).AddMonths(-1).ToString("yyyyMM")
            if ((($tag -match "\d{8}\.\d+") -and ($tag -notmatch "$currentMonthString\d{2}\.\d+") -and ($tag -notmatch "$lastMonthString\d{2}\.\d+")) -or ($tag -match "v\d+\.\d+\.\d+-1803"))
            {
                Write-Info "Deleting $registry\${repository}:$tag"
                AzCommand "acr repository delete -n $registry -t ${repository}:$tag -y"
            }
        }
    }
}
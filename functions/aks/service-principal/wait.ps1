Start-Sleep -Seconds 30
# while($ready -ne "True")
# {
#     $ready = ExecuteQuery "az ad sp show --id $servicePrincipalName --query accountEnabled -o tsv $debugString"
# }
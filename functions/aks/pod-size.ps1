# LaterDo: Add Windows Version (maybe use: IsLinux & IsWindows)

param($deploymentName)

$usage = Write-Usage "aks pod-size <deployment name>"

# function testCommand([ref] $shellCommand, $podName, $tryCommand)
# {
#     if (!$shellCommand.value)
#     {
#         $output = ExecuteQuery "kubectl exec $podName -- $tryCommand 2>&1"
#         $output
#         if ($output)
#         {
#             $shellCommand.value = $tryCommand
#         }
#     }
# }

VerifyCurrentCluster $usage
DeploymentChoiceMenu ([ref]$deploymentName)

$podName = ExecuteQuery ("kubectl get po -l=`"app=$deploymentName`" -o jsonpath='{.items[0].metadata.name}' $kubeDebugString")

Write-Info "Show pod '$podName' content size for the first pod in deployment '$deploymentName'"

# $shellCommand = ""
# testCommand ([ref]$shellCommand) $podName "`"{0} GB`" -f (((Get-ChildItem c:\| Measure-Object -Property Length -sum).Sum / 1024) / 1024)"
# testCommand ([ref]$shellCommand) $podName "du -h -s"

# ExecuteCommand ("kubectl exec $podName -- $shellCommand $kubeDebugString")
ExecuteCommand ("kubectl exec $podName -- du -h -s $kubeDebugString")

# "{0} MB" -f ((Get-ChildItem C:\app\ -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
# "{0} GB" -f (((Get-ChildItem c:\| Measure-Object -Property Length -sum).Sum / 1024) / 1024)
# "{0} MB" -f ((Get-ChildItem c:\| Measure-Object -Property Length -sum).Sum / 1MB)
function SternCommand($regex, $label, $namespace)
{
    $labelString = ConditionalOperator $label " -l app=$label"
    $namespaceString = ConditionalOperator ($namespace -eq "all") " --all-namespaces" (ConditionalOperator $namespace " -n $namespace")

    ExecuteCommand ("stern $regex" + $labelString + $namespaceString)
}
Function Start-NWWorkflows
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$true,ParameterSetname = 1,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('PPN')]
    $ProtectionPolicy,
    [Parameter(Mandatory=$true,ParameterSetname = 1,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('WFN')]
    $WorkflowName,
    [string[]]$clients
    )


Begin
{
$ContentType = "application/json"
$Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()
if ($scope -eq "tenant")
    {
    $scope = "$scope/$tenantid"
    }
$Body = @{clients = @($clients)}
$JsonBody = $Body | ConvertTo-Json
Write-Verbose $JsonBody
}
Process
{
Invoke-WebRequest -Method POST -Uri "$NWbaseurl/global/protectionpolicies/$ProtectionPolicy/workflows/$WorkflowName/op/backup" -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
}
end
{}
}
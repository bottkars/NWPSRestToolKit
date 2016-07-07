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
Function New-NWclient
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false)]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false)]
    $tenantid,

    [alias('hostname')][string]$client,
    [string[]]$aliases,
    [string[]]$applicationInformation,
    [string[]]$saveSets
    )


Begin
    {
    $ContentType = "application/json"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    $Method = "$scope/$Myself/$id"
    $MethodType = 'POST'
    }
Process
    {
    $JsonBody = [ordered]@{hostname = $Hostname
    aliases = @($aliases)
    saveSets = @($saveSets)
    } | ConvertTo-Json
    Write-Verbose $JsonBody
    try
        {
        if ($id)
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody #| Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientRessource";E={$_.id}} -ExcludeProperty ID # .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody #.$Myself | Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientRessourceID";E={$_.id}} -ExcludeProperty ID # @{N="$($Myself)Name";E={$_.ID}} #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }

        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
    }
    End
    {

    }
}

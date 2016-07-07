#PUT /protectiongroups/{protectionGroupId}


function Add-NWClient2ProtectionGroup
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('ClientID')]
    $ClientResourceID,
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$false
                   )][alias('PGName')]
    $ProtectionGroupName,

    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )



begin
{
$Workitems = @()
If (!$ProtectionGroupName)
    {
    Write-Warning "no ProtectionGroup specified"
    break
    }
$ProtectionGroup = Get-NWprotectiongroups -ProtectionGroupName $ProtectionGroupName
if (!$ProtectionGroup)
    {
    Write-Warning "Protectiongroup $ProtectionGroupName not found"
    break
    }

    $ContentType = "application/json"
    $Methodtype = 'PUT'
    $Myself = 'protectiongroups'
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    $Method = "$scope/$Myself/$ProtectionGroupName"
    }
process
{
    $Workitems = $ProtectionGroup.Workitems
    Write-Host "Adding $ClientResourceID to $Workitems"
    $Workitems = $Workitems + $ClientResourceID
    $Workitems = $Workitems | Select-Object -Unique
    $JsonBody = @{ workItems = @($Workitems)} | ConvertTo-Json
    Write-Verbose $JsonBody
    try
        {
        $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
        Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
        $ServicePoint.CloseConnectionGroup("") | Out-Null
        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
}
end
{
Get-NWprotectiongroups -ProtectionGroupName $ProtectionGroupName
}

}
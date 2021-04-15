﻿Function Start-NWWorkflow
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (

    [Parameter(Mandatory=$true,ParameterSetname = 1,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('PPN')]
    $ProtectionPolicy,
    [Parameter(Mandatory=$true,ParameterSetname = 1,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('WFN')]
    $WorkflowName,
    [string[]]$clients,
        [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
                   )]
    $tenantid
    )


Begin
{
$ContentType = "application/json"
$Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()+"s"
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
    [Parameter(Mandatory=$true)][alias('client')][string]$hostname,
    [string[]]$saveSets = @(),
    [string[]]$aliases,
    [string[]]$applicationInformation,
    #[ValidateSet("'Microsoft Exchange Server'")][String]$backuptype,
    [switch]$blockBasedBackup,
    [switch]$checkpointEnabled,
    [switch]$indexBackupContent,
    [switch]$nasDevice,
    [switch]$ndmp,
    [switch]$ndmpMultiStreamsEnabled,
    [string[]]$ndmpVendorInformation,
    [switch]$parallelSaveStreamsPerSaveSet,
    [int16]$parallelism = 4,
    [string]$protectionGroups,
    [string[]]$remoteAccessUsers,
    [switch]$scheduledBackup = $true,
    [string[]]$tags,
    [Parameter(Mandatory=$false)]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false)]
    $tenantid

    )


Begin
    {
    $ContentType = "application/json"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    $Method = "$scope/$Myself/$id"
    $MethodType = 'POST'
    }
Process
    {
    $JsonBody = [ordered]@{hostname = $hostname}
    $JsonBody = $JsonBody + @{blockBasedBackup = $blockBasedBackup.IsPresent.ToString().ToLower()
    checkpointEnabled = $checkpointEnabled.IsPresent.ToString().ToLower()
    indexBackupContent = $indexBackupContent.IsPresent.ToString().ToLower()
    nasDevice = $nasDevice.IsPresent.ToString().ToLower()
    ndmp = $ndmp.IsPresent.ToString().ToLower()
    ndmpMultiStreamsEnabled = $ndmpMultiStreamsEnabled.IsPresent.ToString().ToLower()
    scheduledBackup = $scheduledBackup.IsPresent.ToString().ToLower()
    parallelSaveStreamsPerSaveSet = $parallelSaveStreamsPerSaveSet.IsPresent.ToString().ToLower()
    parallelism = $parallelism
    }
    if ($ndmpVendorInformation) {$JsonBody = $JsonBody + @{ndmpVendorInformation = ($ndmpVendorInformation)}}
    if ($protectionGroups) {$JsonBody = $JsonBody + @{protectionGroups = ($protectionGroups)}}
    if ($remoteAccessUsers) {$JsonBody = $JsonBody +@{remoteAccessUsers = ($remoteAccessUsers)}}
    if ($saveSets) {$JsonBody = $JsonBody + @{saveSets = @($saveSets)}}
    if ($aliases) {$JsonBody = $JsonBody + @{aliases = @($aliases)}}
    if ($applicationInformation) {$JsonBody = $JsonBody + @{applicationInformation = @($applicationInformation)}}
    if ($backuptype) {$JsonBody = $JsonBody + @{backupType = $backuptype}}
    if ($tags) {$JsonBody = $JsonBody + @{tags = ($tags)}}
    #}
    $JsonBody = $JsonBody  |ConvertTo-Json
    Write-Verbose $JsonBody
    try
        {
        if ($id)
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
            }
        else
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
            }

        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
    Get-NWclients | where hostname -Match $hostname | select -First 1
    }
    End
    {

    }
}
<#New-NWdevice
<#POST /nwrestapi/v1/global/devices
{
"name": "/space/storage",

"deviceAccessInfo": "/space/storage",
"mediaType": "adv_file"
}#>
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$true)][alias('client')][string]$hostname,
    [string[]]$saveSets = @(),
    [string[]]$aliases,
    [string[]]$applicationInformation,
    #[ValidateSet("'Microsoft Exchange Server'")][String]$backuptype,
    [switch]$blockBasedBackup,
    [switch]$checkpointEnabled,
    [switch]$indexBackupContent,
    [switch]$nasDevice,
    [switch]$ndmp,
    [switch]$ndmpMultiStreamsEnabled,
    [string[]]$ndmpVendorInformation,
    [switch]$parallelSaveStreamsPerSaveSet,
    [int16]$parallelism = 4,
    [string]$protectionGroups,
    [string[]]$remoteAccessUsers,
    [switch]$scheduledBackup = $true,
    [string[]]$tags,
    [Parameter(Mandatory=$false)]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false)]
    $tenantid

    )


Begin
    {
    $ContentType = "application/json"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    $Method = "$scope/$Myself/$id"
    $MethodType = 'POST'
    }
Process
    {
    $JsonBody = [ordered]@{hostname = $hostname}
    $JsonBody = $JsonBody + @{blockBasedBackup = $blockBasedBackup.IsPresent.ToString().ToLower()
    checkpointEnabled = $checkpointEnabled.IsPresent.ToString().ToLower()
    indexBackupContent = $indexBackupContent.IsPresent.ToString().ToLower()
    nasDevice = $nasDevice.IsPresent.ToString().ToLower()
    ndmp = $ndmp.IsPresent.ToString().ToLower()
    ndmpMultiStreamsEnabled = $ndmpMultiStreamsEnabled.IsPresent.ToString().ToLower()
    scheduledBackup = $scheduledBackup.IsPresent.ToString().ToLower()
    parallelSaveStreamsPerSaveSet = $parallelSaveStreamsPerSaveSet.IsPresent.ToString().ToLower()
    parallelism = $parallelism
    }
    if ($ndmpVendorInformation) {$JsonBody = $JsonBody + @{ndmpVendorInformation = ($ndmpVendorInformation)}}
    if ($protectionGroups) {$JsonBody = $JsonBody + @{protectionGroups = ($protectionGroups)}}
    if ($remoteAccessUsers) {$JsonBody = $JsonBody +@{remoteAccessUsers = ($remoteAccessUsers)}}
    if ($saveSets) {$JsonBody = $JsonBody + @{saveSets = @($saveSets)}}
    if ($aliases) {$JsonBody = $JsonBody + @{aliases = @($aliases)}}
    if ($applicationInformation) {$JsonBody = $JsonBody + @{applicationInformation = @($applicationInformation)}}
    if ($backuptype) {$JsonBody = $JsonBody + @{backupType = $backuptype}}
    if ($tags) {$JsonBody = $JsonBody + @{tags = ($tags)}}
    #}
    $JsonBody = $JsonBody  |ConvertTo-Json
    Write-Verbose $JsonBody
    try
        {
        if ($id)
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
            }
        else
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -Body $JsonBody
            }

        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
    Get-NWclients | where hostname -Match $hostname | select -First 1
    }
    End
    {

    }
}
#>
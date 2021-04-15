function Get-NWAlert
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWAuditlogconfig
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ) #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWBackup
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,ParameterSetname = 1
                   #ValueFromPipeline=$true
                   )][alias('bid')]
    $BackupID,
    [Parameter(Mandatory=$true,ParameterSetname = "ClientID",
                   ValueFromPipelineByPropertyName=$true
                   )][alias('ClientID')]
    $ClientResourceID,
    [switch]$Instances,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$BackupID"
    $MethodType = 'GET'
    try
        {
        switch ($PsCmdlet.ParameterSetName)
            {
            "ClientID"
                {
                $Method = "$scope/clients/$ClientResourceID/$Myself"
                (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself |
                Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))Name";E={$_.name}},@{N="$($MyInvocation.MyCommand.Name.Substring(6))ID";E={$_.id}} -ExcludeProperty links,ID,name 
                }
            default
                {
                if ($BackupID)
                    {
                    If ($Instances.IsPresent)
                        {
                        $Method = "$Method/instances"
                        Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType | 
                        Select-Object * -ExcludeProperty backupInstances,links -ExpandProperty backupInstances |
                        Select-Object *,@{N="InstanceID";E={$_.id}} -ExcludeProperty id,links
                         # .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                        }
                    else
                        {
                        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ) | # .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                        Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))Name";E={$_.name}},@{N="$($MyInvocation.MyCommand.Name.Substring(6))ID";E={$_.id}} -ExcludeProperty links,ID,name 
                        }
                    }
                else
                    {
                    (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself |
                    Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))Name";E={$_.name}},@{N="$($MyInvocation.MyCommand.Name.Substring(6))ID";E={$_.id}} -ExcludeProperty links,ID,name 
                    }
                }
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
function Get-NWClient
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )][alias('Clientid','ID')]
    $ClientRessourceId,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('ClientName')]
    $hostname,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$ClientRessourceId"
    $MethodType = 'GET'
    try
        {
        if ($ClientRessourceId)
            {
            $MyClients = Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType | 
            Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))ResourceID";E={$_.id}} -ExcludeProperty ID 
            }
        else
            {
            $MyClients = (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself |
            Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))ResourceID";E={$_.id}} -ExcludeProperty ID 
            }
        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
    if ($hostname)
        {
        Write-Output $MyClients | where hostname -eq $hostname
        }
    else
        {
        Write-Output $MyClients
        }
    }
    End
    {

    }
}
function Get-NWDevice
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('Devname')]
    $DeviceName,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$DeviceName"
    $MethodType = 'GET'
    try
        {
        if ($DeviceName)
            {
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))Name";E={$_.name}} -ExcludeProperty links,ID,resourceID,name -ExpandProperty resourceID |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))ResourceID";E={$_.id}} -ExcludeProperty ID 
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))Name";E={$_.name}} -ExcludeProperty links,ID,resourceID,name -ExpandProperty resourceID |
            Select-Object *,@{N="$($MyInvocation.MyCommand.Name.Substring(6))RessourceID";E={$_.id}} -ExcludeProperty ID 
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
function Get-NWDirective
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('did')]
    $DirectiveID,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$DirectiveID"
    $MethodType = 'GET'
    try
        {
        if ($DirectiveID)
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWJobgroup
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).jobs | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWJobindication
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"

    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWJob
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Jid')]
    $JobID,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$JobID"
    $MethodType = 'GET'
    try
        {
        if ($JobID)
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWLabel
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('lid')]
    $LabelID,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$LabelID"
    $MethodType = 'GET'
    try
        {
        if ($LabelID)
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWNotification
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWPool
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Pid')]
    $PoolID,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6)
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$PoolID"
    $MethodType = 'GET'
    try
        {
        if ($PoolID)
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWProbe
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWProtectiongroup
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )][alias('Name')]
    $ProtectionGroupName,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$ProtectionGroupName"
    $MethodType = 'GET'

        try
        {
        if ($ProtectionGroupName)
            {
            #$ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
            Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType | Select-Object * -ExcludeProperty links,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ProtectionGroupResourceID";E={$_.id}} -ExcludeProperty ID 
            #$ServicePoint.CloseConnectionGroup("") | Out-Null
            }
        else
            {
            #$ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ProtectionGroupResourceID";E={$_.id}} -ExcludeProperty ID 
            #$ServicePoint.CloseConnectionGroup("") | Out-Null
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
function Get-NWProtectionpolicies
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid

    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWServerconfig
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ) #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWSession
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWStoragenode
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWUsergroup
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWVolume
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()+"s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWWorkflow
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$true,ParameterSetname = 1,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('name')]
    $PolicyName,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]
    $scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
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
    }
    Process
    {
    $Method = "$scope/protectionpolicies/$PolicyName/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object *,@{N="ProtectionPolicy";E={$PolicyName}},@{N="$($Myself -replace ".$")Name";E={$_.name}} -ExcludeProperty links,name #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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

function Get-NWalerts
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWauditlogconfig
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWbackups
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
    [Parameter(Mandatory=$false,Position = 0,ParameterSetname = 1
                   #ValueFromPipeline=$true
                   )][alias('backupid')]
    $Id,
    [Parameter(Mandatory=$true,ParameterSetname = "ClientID",
                   ValueFromPipelineByPropertyName=$true
                   )][alias('ClientID')]
    $ClientResourceID


    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        switch ($PsCmdlet.ParameterSetName)
            {
            "ClientID"
                {
                $Method = "$scope/clients/$ClientResourceID/$Myself"
                (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links,id,instances -ExpandProperty instances #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                }
            default
                {
                if ($Id)
                    {
                    (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                    }
                else
                    {
                    (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWclients
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )][alias('Clientid','ClientResourceID')]
    $Id,
        [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('ClientName')]
    $hostname


    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
            {
            #$ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
            $MyClients = Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType  | Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientResourceID";E={$_.id}} -ExcludeProperty ID # .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            #$ServicePoint.CloseConnectionGroup("") | Out-Null
            }
        else
            {
            #$ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
            $MyClients = (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientResourceID";E={$_.id}} -ExcludeProperty ID # @{N="$($Myself)Name";E={$_.ID}} #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            #$ServicePoint.CloseConnectionGroup("") | Out-Null
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
function Get-NWdevices
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Deviceid')]
    $Id

    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
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
function Get-NWdirectives
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Directiveid')]
    $Id

    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
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
function Get-NWjobgroups
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWjobindications
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWjobs
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Jobid')]
    $Id

    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
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
function Get-NWlabels
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('labelid')]
    $Id

    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
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
function Get-NWnotifications
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWpools
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid,
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('Poolid')]
    $Id

    )
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
    $Method = "$scope/$Myself/$id"
    $MethodType = 'GET'
    try
        {
        if ($id)
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
function Get-NWprobes
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWprotectiongroups
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ProtectionGroupResourceID";E={$_.id}} -ExcludeProperty ID #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
function Get-NWprotectionpolicies
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWserverconfig
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWsessions
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWstoragenodes
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWusergroups
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
function Get-NWvolumes
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
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
#GET /protectionpolicies/{policyId}/workflows#
function Get-NWWorkflows
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
                   )][alias('ClientID')]
    $PolicyName


    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()
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



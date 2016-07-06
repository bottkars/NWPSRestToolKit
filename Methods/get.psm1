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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ) #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
    [Parameter(Mandatory=$false,Position = 0,
                   ValueFromPipeline=$true
                   )][alias('id')]
    $ClientId

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
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
        else
            {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).jobs | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ) #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
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

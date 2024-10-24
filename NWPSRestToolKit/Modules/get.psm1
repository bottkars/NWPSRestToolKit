function Get-NWAlert {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid

    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = 'GET'
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        } 
        try {
        $Result=Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Output $result.$Myself
    }
}
function Get-NWAuditlogconfig {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid

    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = 'GET'
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        } 
        try {
        Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}


function Get-NWJobgroup {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).jobs | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWJobindication {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid

    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"

        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}

function Get-NWLabel {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false, Position = 0,
            ValueFromPipeline = $true
        )][alias('lid')]
        $LabelID,
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself/$LabelID"
        $MethodType = 'GET'
        try {
            if ($LabelID) {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
            else {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }

        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWNotification {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWPool {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false, Position = 0,
            ValueFromPipeline = $true
        )][alias('Pid')]
        $PoolID,
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true
        )]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true
        )]
        $tenantid    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6)
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself/$PoolID"
        $MethodType = 'GET'
        try {
            if ($PoolID) {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType )# .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }
            else {
            (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
            }

        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWProbe {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}


function Get-NWServerconfig {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }


    Process {
        $Method = 'GET'
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        } 
        try {
        Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }

#    Process {
#        $Method = "$scope/$Myself"
#        $MethodType = 'GET'
#        try {
#        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ) #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
#        }
#        catch {
#            Get-NWWebException -ExceptionMessage $_
#            return
#        }
 #   }
 ##   End {
#
#    }
}
function Get-NWSession {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWStoragenode {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
function Get-NWUsergroup {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {
        $Method = "$scope/$Myself"
        $MethodType = 'GET'
        try {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType ).$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {

    }
}
<#function Get-NWVolume
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
#>

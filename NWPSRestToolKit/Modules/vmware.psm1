# /vmware/vcenters/{vcenter-hostname}/protectedvms

function Get-NWprotectedvms {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string[]]$vmName,
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        $vCenterHostname,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "vmware/vcenters/$vCenterHostname/protectedvms"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $body = @{}
        if ($vmName) {
            $body.Add('q', "name:$($vmName -join ',')")
        }
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" { 
                Write-Output $local:Response
            }
            Default {
                if ($hostname) {
                    Write-Output $local:Response.vms # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response.vms
                }                

            }
        }

    }
    End {

    }
}


function Get-NWprotectedvmdetails {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string]$uuid,
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        $vCenterHostname,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $Myself = "vmware/vcenters/$vCenterHostname/vms/$uuid/protectiondetails"

        $body = @{}
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" { 
                Write-Output $local:Response
            }
            Default {
                if ($hostname) {
                    Write-Output $local:Response # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response.protectionDetails
                }                

            }
        }

    }
    End {

    }
}




#GET
##Returns a list of active virtual machines.
#/vmware/vms

function Get-NWVMwareVMs {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string[]]$vmName,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "vmware/vms"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }

        
    Process {
        $body = @{}
        if ($vmName) {
            $body.Add('q', "name:$($vmName -join ',')")
        }
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" { 
                Write-Output $local:Response
            }
            Default {
                if ($hostname) {
                    Write-Output $local:Response.vms # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response.vms
                }                

            }
        }

    }
    End {

    }
}



<#
POST /nwrestapi/v3/global/vmware/vcenters/hostname.company.com/vms/5008edbaedfe-
127c-1d00-68830b14b0fc/op/backup
{
"policy" : "ApiPolicy",
"workflow" : "ApiWorkflow"
}
#>


function Start-NWprotectedVMBackup {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string]$uuid,
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        $vCenterHostname,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
    }
    Process {
        Write-Host "Reading VM Protection Detail for vmuuid $UUID on vcenter $VCENTERHostname"
        $ProtectionDetails = Get-NWprotectedvmdetails -uuid $uuid -vCenterHostname $vCenterHostname
        $Myself = "vmware/vcenters/$vCenterHostname/vms/$uuid/op/backup"

        $body = @{}
        $body.Add('workflow', $ProtectionDetails.workflow.name)
        $body.Add('policy', $ProtectionDetails.protectionPolicy.name)
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body | convertto-json
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" { 
                Write-Output $local:Response
            }
            Default {
                if ($hostname) {
                    Write-Output $local:Response # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response
                }                

            }
        }

    }
    End {

    }
}









# /vmware/vcenters/{vcenter-hostname}/protectedvms/{vm-uuid}/backups
# [start of time range TO end of time range] or in form of [N hours] or [N days]
function Get-NWProtectedvmBackups {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $uuid,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $vCenterHostname,        
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('hours', 'days')]
        [string]$unit = "Days",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [string]$count = 90,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('attributes',
        'browseTime',
        'clientHostname',
        'clientId',
        'completionTime',
        'creationTime',
        'fileCount',
        'id',
        'instances',
        'level',
        'links',
        'name',
        'retentionTime',
        'saveTime',
        'shortId',
        'size',
        'type',
        'vmInformation')]
        [string[]]$Filter,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $body = @{}
        $body.Add('q', "saveTime:[$count $unit]")            
        if ($Filter){
            $body.Add('fl',"$($filter -join ',')")
        }
        $Myself = "vmware/vcenters/$vcenterHostname/protectedvms/$uuid/backups"
        Write-Verbose $uuid
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
            Headers       = @{}
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)


        Write-Output $local:Response.backups

    }


    End {

    }
}

# /protectiongroups/{protectionGroupId}/op/updatevmwareworkitems
# post
function Set-NWVMwareWorkitems {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false, ParameterSetName = "default")]
        [string[]]$addvmUUId,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false, ParameterSetName = "default")]
        [string[]]$addMorefs,        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false, ParameterSetName = "default")]
        [string[]]$delvmUUId, 
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false, ParameterSetName = "default")]
        [string[]]$delMorefs,                
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        $vCenterHostname,
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        $protectionGroupId,        
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "protectiongroups/$protectionGroupId/op/updatevmwareworkitems"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
    }

        
    Process {

        $body = @{}
        if ($addvmUUId -or $addMorefs) {
            
            $body.Add('addWorkItems', @{})
            $body.addWorkItems.Add('vCenterHostname', $vCenterHostname)
            $body.addWorkItems.Add('vmUuids', $addvmUUId)
            $body.addWorkItems.Add('containerMorefs', $addMorefs)
        }
        if ($delvmUUId -or $delMorefs) {
            
            $body.Add('deleteWorkItems', @{})
            $body.deleteWorkItems.Add('vCenterHostname', $vCenterHostname)
            $body.deleteWorkItems.Add('vmUuids', $delvmUUId)
            $body.deleteWorkItems.Add('containerMorefs', $delMorefs)
        }        
        Write-Verbose $body | Out-String
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body | convertto-json
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" { 
                Write-Output $local:Response
            }
            Default {
                if ($hostname) {
                    Write-Output $local:Response.vms # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response.vms
                }                

            }
        }

    }
    End {

    }
}
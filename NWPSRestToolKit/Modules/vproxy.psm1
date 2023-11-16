# post /vmware/vproxies/op/register
<#

{
  "enabled": true,
  "hostname": "10.63.30.90",
  "maxHotaddSessions": 13,
  "maxNbdSessions": 13,
  "userName": "admin",
  "vCenterHostname": "10.63.30.165",
  "password": "password",
  "vProxyPort": 9090
}
#>

function Register-NWvProxy {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)][alias('hostname')]
        $name,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)][alias('vc')]
        $vCenterHostname,    
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)][alias('proxyuser')]
        $userName,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)][alias('proxypassword')]
        $password,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][alias('port')]
        $vProxyPort = "9090",
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][alias('maxhotadd')]
        $maxHotaddSessions = 13,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][alias('maxnbd')]
        $maxNbdSessions = 13,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$enabled,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $Myself = "vmware/vproxies/op/register"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
    }
    Process {
        $body = @{}
        $body.Add('hostname', $name)
        $body.Add('enabled', $enabled.IsPresent)
        $body.Add('vCenterHostname', $vCenterHostname)
        $body.Add('userName', $userName)
        $body.Add('password', $password)
        $body.Add('vProxyPort', $vProxyPort)
        $body.Add('maxHotaddSessions', $maxHotaddSessions)
        $body.Add('maxNbdSessions', $maxNbdSessions)
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body | ConvertTo-Json
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Response | Out-String)
        Write-Output $local:Response
    }
}


# /vmware/vproxies
function Get-NWvProxies {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ParameterSetName = "ByName")][alias('DDName')]
        $name,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "vmware/vproxies"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            'ByName' {
                Write-Output $local:Response.vProxies
            }
            default {
                Write-Output $local:Response.vProxies
            }
        }

    }
}


#### https://nve.home.labbuildr.com:9090/nwui/api/groups/Gold-Vmware
# Request Method: PUT

<#
{
	"comment": "Default protection group for workflow Gold/VMware",
	"name": "Gold-Vmware",
	"source": "Static",
	"subType": "All",
	"type": "VMware",
	"policy": "Gold",
	"workflow": "VMware",
	"rdz": null,
	"vcenter": "vcsa1.home.labbuildr.com",
	"backupOptimization": "Capacity",
	"rule": null,
	"containerMorefidList": [],
	"vmUuidList": ["501b6968-1720-3794-a7d2-9ac505e80ffc"],
	"vmdkMappings": {},
	"vmUuidExclusionList": [],
	"vmdkExclusionMappings": {},
	"dynamicAssociation": true,
	"filterType": "",
	"currentPage": "vmResources"
}
#>

function Update-NWvProxies {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
        [alias('vProxyName')]
        $hostname,
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        [string]$comments,
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 9)][int]$debugLevel = 0, 
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(10, 1440)][int]$timeoutInMins = 10, 
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        [string]$rootPasswd,  
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        [switch]$DontuseAdminPWasRoot,                                 
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
        $Body = @{}
        $body.add('comments', $comments)
        $body.add('debugLevel', $debugLevel)
        $body.add('timeoutInMins', $timeoutInMins)
        if ($DontuseAdminPWasRoot.IsPresent) {
            $body.add('rootPasswd', $rootPasswd)
        }          
        else {  
            $body.add('adminPasswordAsRoot', "true")
        }
        $body = $Body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod           = "REST"
            body                    = $body 
            Method                  = $Method
            Uri                     = "$scope/vmware/vproxies/$hostname/op/redeployment"
            Verbose                 = $PSBoundParameters['Verbose'] -eq $true
            ResponseHeadersVariable = "HeaderResponse"
        }    
        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Response | Out-String)
        If ($Response.'Location') {
            $JOB = $Response.'Location' | split-path -Leaf 
            Get-NWJobs -id $JOB            
        }

    }
}

function Get-NWvProxiesRedeployment {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
        [alias('vProxyName')]
        $hostname,
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
        $Body = @{}
        $body = $Body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod           = "REST"
            body                    = $body 
            Method                  = $Method
            Uri                     = "$scope/vmware/vproxies/$hostname/op/redeployment"
            Verbose                 = $PSBoundParameters['Verbose'] -eq $true
#            ResponseHeadersVariable = "HeaderResponse"
        }    
        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            'ByName' {
                Write-Output $local:Response
            }
            default {
                Write-Output $local:Response
            }
        }

    }
}

## https://nve.home.labbuildr.com:9090/nwui/api/sessions?type=vproxy

function Get-NWvProxiesRedeploymentTasks {
    [CmdletBinding()]
    Param
    (

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
        $Body = @{}
        $body = $Body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod           = "REST"
            body                    = $body 
            Method                  = $Method
            Uri                     = "nwui/api/sessions?type=vproxy"
            Verbose                 = $PSBoundParameters['Verbose'] -eq $true
            API                     = "nwui/api/"
#            ResponseHeadersVariable = "HeaderResponse"
        }    
        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Response | Out-String)
        switch ($PSCmdlet.ParameterSetName) {
            'ByName' {
                Write-Output $local:Response
            }
            default {
                Write-Output $local:Response
            }
        }

    }
}
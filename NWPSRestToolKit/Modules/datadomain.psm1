

function Get-NWDatadomainSystem {
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
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
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
            Uri           = "$scope/$myself/$name"
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
                Write-Output $local:Response
            }
            default {
                Write-Output $local:Response.$Myself
            }
        }

    }
}
# (Invoke-NWAPIRequest -uri global/datadomainsystems -Method get -RequestMethod Rest ).datadomainsystems # (Invoke-NWAPIRequest -uri global/datadomainsystems -Method get -RequestMethod Rest ).datadomainsystems 
<#{
POST /nwrestapi/v3/global/datadomainsystems/10.125.32.204/op/listunits
  }#>

  function Get-NWDatadomainSystemUnits {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $true)][alias('DDName')]
        $name,
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "datadomainsystems"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
        $body = @{} | ConvertTo-Json
    }
    Process {
        $Parameters = @{
            RequestMethod = "REST"
            body    = $body 
            Method  = $Method
            Uri     = "$scope/$myself/$name/op/listunits"
            Verbose = $PSBoundParameters['Verbose'] -eq $true
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

function New-NWDatadomainSystemUnit {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $true)][alias('DDName')]
        $name,
        [Parameter(Mandatory = $True,ValueFromPipelineByPropertyName = $true)][alias('unit')]
        $storageUnit,        
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "datadomainsystems"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
    }
    Process {
        $body = @{} 
        $body.Add('storageUnit',$storageUnit)
        $Parameters = @{
            RequestMethod = "REST"
            body    = $body | ConvertTo-Json
            Method  = $Method
            Uri     = "$scope/$myself/$name/op/createunit"
            Verbose = $PSBoundParameters['Verbose'] -eq $true
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


function New-NWDataDomainSystem {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)][alias('ddUser')]
        $ddUsername,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)][securestring][alias('pw')]
        $ddpassword,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)][alias('name')]
        $ddname,        
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)][string[]][alias('alias')]
        $ddaliases,        


        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        $local:Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "POST"
        $Body = @{}
        $Body.Add('userName', $ddusername)
        $Body.Add('password', [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ddpassword)))
        $Body.Add('name', $ddname)
        $Body.Add('aliases', $ddaliases)
    }
    Process {

        $Parameters = @{
            body          = $body | ConvertTo-Json
            RequestMethod = "REST"
            Method        = $Method
            Uri           = "$scope/$myself"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $local:Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Result | Out-String)
        if ($hostname) {
            Write-Output $local:Result
        }
        else {
            Write-Output $local:Result
        }

    }
}



function Update-NWDataDomainSystem {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true, ParameterSetName = "withddUser")]
        [alias('ddUser')]
        $ddUsername,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true, ParameterSetName = "withddUser")]
        [securestring][alias('pw')]
        $ddpassword,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true, ParameterSetName = "withManagementUser")]
        [alias('mgmtUser')]
        $ManagementUsername,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true, ParameterSetName = "withManagementUser")]
        [securestring][alias('mgmtpw')]
        $Managementpassword,        
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)][alias('name')]
        $ddname,        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][string[]][alias('alias')]
        $ddaliases,        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][string]
        $snmpCommunityString,  
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)][string]
        $storageNode,
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false,ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(9).ToLower() + "s"
        $local:Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "PUT"
        	
    }
    Process {
        $Body = @{}
        switch ($PSCmdlet.ParameterSetName)
        {
            'withManagementuser' {
                $Body.Add('managementUser', $Managementusername)
                $Body.Add('managementPassword', [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Managementpassword)))
            }

            'withDDUser' {
                $Body.Add('userName', $ddusername)
                $Body.Add('password', [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ddpassword)))
            }
        }
        if ($aliases) {
            $Body.Add('aliases', $ddaliases)
        }
        if ($snmpCommunityString) {
            $Body.Add('snmpCommunityString', $snmpCommunityString)
        }
        if ($storageNode) {
            $Body.Add('storageNode', $storageNode)
        }                
        $body = $Body | ConvertTo-Json
        Write-Verbose ($body | out-string)	
        $Parameters = @{
            body          = $body 
            RequestMethod = "REST"
            Method        = $Method
            Uri           = "$scope/$myself/$ddname"
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
            ResponseHeadersVariable = 'HeaderResponse'            
        }    
        try {
            $local:Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Result | Out-String)

            Write-Output $local:Result

    }
}
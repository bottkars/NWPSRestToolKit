

function Get-NWDatadomainSystem {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'byID',
            ValueFromPipelineByPropertyName = $true
        )][alias('Id')]
        $dataDomainSystemId,
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
        $local:Result = @()
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
            Uri           = "$scope/$myself/$dataDomainSystemId"
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
        switch ($PSCmdlet.ParameterSetName) {
            'byID' {
                Write-Output $local:Result
            }
            Default {
                Write-Output $local:Result.$Myself
            }
        }
        



    }
}
# (Invoke-NWAPIRequest -uri global/datadomainsystems -Method get -RequestMethod Rest ).datadomainsystems 
<#{
    "name": "10.125.32.201",
    "aliases": "10.125.32.201",
    "userName": "sysadmin",
    "password": "password123"
  }#>
function New-NWDataDomainSystem {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, Position = 0,
            ValueFromPipelineByPropertyName = $true
        )][alias('ddUser')]
        $ddUsername,
        [Parameter(Mandatory = $true, Position = 0,
            ValueFromPipelineByPropertyName = $true
        )][securestring][alias('pw')]
        $ddpassword,
        [Parameter(Mandatory = $true, Position = 0,
            ValueFromPipelineByPropertyName = $true
        )][alias('name')]
        $ddname,        
        [Parameter(Mandatory = $true, Position = 0,
            ValueFromPipelineByPropertyName = $true
        )][string[]][alias('alias')]
        $ddaliases,        


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

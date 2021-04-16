function Get-NWVolume {
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
        $Response= @()
        $Method = "GET"
    }

    Process {
        $Parameters = @{
            body    = $body 
            Method  = $Method
            Uri     = "$scope/$myself"
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($Response | Out-String)
        if ($hostname) {
            Write-Output ($Response.Content | ConvertFrom-Json).$Myself | Where-Object name -match $name
        }
        else {
            Write-Output ($Response.Content | ConvertFrom-Json).$Myself
        }
    
    }
}
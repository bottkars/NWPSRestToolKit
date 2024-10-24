function Get-NWRecoverApps {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Get-NWProtectionGroup')]
    Param
    (


#        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")][alias('ProtectionGroupName')]
#        $name,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
        $body = @{}
    }

        
    Process {
    
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
                if ($name) {
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



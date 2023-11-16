

function Get-NWDirectives {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipelineByPropertyName = $true)]
        $DeviceName,
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
        if ( $DeviceName) {
            Write-Output $local:Response
        }
        else {
            Write-Output $local:Response  <# Action when all if and elseif conditions are false #>
        }
        

    }
}
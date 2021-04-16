function Get-NWJob {
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
        $MyClients = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $Parameters = @{
            body    = $body 
            Method  = $Method
            Uri     = "$scope/$myself/$ClientRessourceId"
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $Method = "$scope/$Myself/$ClientRessourceId"
            $MethodType = 'GET'
            $MyClients += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($MyClients | Out-String)
        Write-Output ($MyClients.Content | ConvertFrom-Json).$Myself
    }
    End {

    }
}
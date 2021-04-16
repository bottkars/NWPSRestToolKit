function Get-NWClient {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "ByID")]
        [alias('ResID')]
        $ClientId,
        [Parameter(Mandatory = $false, ParameterSetName = "ByID")]
        [switch]$Agents,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true)][alias('ClientName')]
        $hostname,
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
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($Agents.IsPresent) {
            $Parameters.Add('Uri', "$scope/$myself/$ClientId/agents")
        }  
        else {
            $Parameters.Add('Uri', "$scope/$myself/$ClientId")

        } 
        try {
            $MyClients += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($MyClients | Out-String)
        if ($hostname) {
            Write-Output $MyClients.$Myself | Where-Object hostname -match $hostname 
        }
        else {
            Write-Output $MyClients.$Myself 
        }
    }
    End {

    }
}
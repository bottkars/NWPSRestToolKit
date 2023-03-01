function Get-NWClient {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "ByID")]
        [alias('ResID')]
        $ClientId,
        [Parameter(Mandatory = $false, ParameterSetName = "ByID")]
        [switch]$Agents,

        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")][alias('ClientName')]
        $hostname,
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
        $body = @{}
    }

        
    Process {
        
        if ($hostname)
        {
            $body.Add('q',"hostname:$hostname")
        }    
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
                    Write-Output $local:Response.$Myself # | Where-Object hostname -match $hostname 
                }
                else {
                    Write-Output $local:Response.$Myself 
                }                

            }
        }

    }
    End {

    }
}

# Post /clients/{clientId}/op/backup
function Start-NWClientBackup {

    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [alias('ResID', 'ID')]
        $ClientId,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $WorkflowName,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $PolicyName,
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
        $Method = "POST"
        If ($WorkflowName -or $PolicyName) {
            $Body = @{}
            If ($PolicyName) { $body.Add('policy', $PolicyName) }
            If ($WorkflowName) { $body.Add('workflow', $WorkflowName) }
            $body = $Body | ConvertTo-Json
        }
    }
    Process {
        
        $Parameters = @{
            RequestMethod = "REST"
            URI           = "$scope/clients/$clientId/op/backup"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
            ResponseHeadersVariable = 'HeaderResponse'
        }

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)


    }
    End {
        switch ($PSCmdlet.ParameterSetName) {

            Default {

                Write-Output $local:Response
               

            }
        }
    }
}




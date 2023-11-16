function Get-NWProtectiongroups {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Get-NWProtectionGroup')]
    Param
    (


        [Parameter(Mandatory = $false, Position = 0, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")][alias('ProtectionGroupName')]
        $name,
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

        $Parameters.Add('Uri', "$scope/$myself/$([System.Web.HTTPUtility]::UrlEncode($name))")

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
                    Write-Output $local:Response.$Myself 
                }                

            }
        }

    }
    End {

    }
}


function Add-NWClient2ProtectionGroup
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )][alias('ClientID')]
        $ClientResourceID,
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $false
        )][alias('PGNames')]
        [string[]]$protectionGroups,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )



    begin {

        $ContentType = "application/json"
        $Method = 'PUT'
        $Myself = 'protectiongroups'
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }


    }
    process { 
        $body= @{}
        $URI = "$scope/clients/$ClientResourceID"
        $body.Add('protectionGroups',$protectionGroups)
        $Body = $body | ConvertTo-Json
        Write-Verbose ($body | out-string)
        $Parameters = @{
            RequestMethod = "REST"
            body = $body
            URI = $URI 
            Method  = $Method
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        }

        Write-Verbose ($Parameters | out-string)
        try {

            $Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    end {

    }

}
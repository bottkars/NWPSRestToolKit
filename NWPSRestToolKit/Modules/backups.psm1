function Get-NWBackups {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Get-NWBackup')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = "byID",
            ValueFromPipelineByPropertyName = $true)]
        [alias('bid')]
        $BackupID,
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
            ValueFromPipelineByPropertyName = $true)]
        [alias('id')]
        $InstanceID,        
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
            ValueFromPipelineByPropertyName = $true)]        
        [switch]$Instances,
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )

    Begin {
        Write-Verbose ( $MyInvocation | Out-String )
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
        $Result = @()
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
        if ($Instances.IsPresent) {
            $Parameters.Add('URI', "$scope/$myself/$BackupID/instances/$InstanceID")
        }
        else {
            $Parameters.Add('URI', "$scope/$myself/$BackupID")
        }
   
        try {

            $Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }

    End {
        Write-Verbose ( $Result | Out-String )        
        switch ($PSCmdlet.ParameterSetName) {
            "ByID" {
                if ($Instances.IsPresent -and (!$InstanceID)) {
                    Write-Output $Result.backupInstances
                }
                else {
                    Write-Output $Result
                }
            }
            Default {
                Write-Output $Result.$Myself
            }
        }

    }
}


function Get-NWClientBackups {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [alias('ResID', "ID")]
        $resourceId,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = "clients"
        $local:Response = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        Write-Verbose $resourceId.id
        If ($resourceId.id) {
            $ClientId = $resourceId.id
        }
        else {
            $ClientId = $resourceId
            <# Action when all if and elseif conditions are false #>
        }
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }

        $Parameters.Add('Uri', "$scope/$myself/$ClientId/backups")

        try {
            $local:Response += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        Write-Verbose ($local:Response | Out-String)


        Write-Output $local:Response.backups

    }


    End {

    }
}


function Remove-NWBackups {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Remove-NWBackup')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = "byID",
            ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetname = "byInstanceID",
            ValueFromPipelineByPropertyName = $true)]
        [alias('bid')]
        $BackupID,
        [Parameter(Mandatory = $true, ParameterSetname = "byInstanceID",
            ValueFromPipelineByPropertyName = $true)]
        [alias('id')]
        $InstanceID,        
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $false
        )]
        $tenantid
    )

    Begin {
        Write-Verbose ( $MyInvocation | Out-String )
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(9).ToLower()
        $Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "DELETE"
    }
    Process {
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
            ContentType   = $ContentType
        }

        switch ($PSCmdlet.ParameterSetName) {
            "ByID" {
                $Parameters.Add('URI', "$scope/$myself/$BackupID")
            }
            "ByInstanceId" {
                $Parameters.Add('URI', "$scope/$myself/$BackupID/instances/$InstanceID")                
            }
        }    
        try {

            $Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
  

    End {
        Write-Verbose ( $Result | Out-String )        
        switch ($PSCmdlet.ParameterSetName) {

            Default {
                Write-Output $Result
            }
        }

    }
}

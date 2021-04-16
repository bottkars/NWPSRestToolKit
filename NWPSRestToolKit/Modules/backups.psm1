function Get-NWBackup {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]
        [alias('bid')]
        $BackupID,
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]
        [alias('id')]
        $InstanceID,        
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]        
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
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower() + "s"
        $Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        $Parameters = @{
            RequestMethod = "REST"
            body    = $body 
            Method  = $Method
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        }
        if ($Instances.IsPresent) {
            $Parameters.Add('URI',"$scope/$myself/$BackupID/instances/$InstanceID")
        }
        else {
            $Parameters.Add('URI',"$scope/$myself/$BackupID")
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
        switch ($PSCmdlet.ParameterSetName){
            "ByID"{
                if ($Instances.IsPresent -and (!$InstanceID)) {
                    Write-Output $Result.backupInstances
                }
                else {
                    Write-Output $Result
                }
            }
            Default{
                Write-Output $Result.$Myself
            }
        }

    }
}

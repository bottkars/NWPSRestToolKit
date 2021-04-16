function Get-NWProtectionPolicies {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]
        [alias('pid')]
        $PolicyName,
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]
        [alias('wid')]
        $WorkflowName,        
        [Parameter(Mandatory = $false, ParameterSetname = "byID",
        ValueFromPipelineByPropertyName=$true)]        
        [switch]$workflows,
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
            body    = $body 
            Method  = $Method
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        }
        $PolicyName=[System.Web.HTTPUtility]::UrlEncode($PolicyName)
        $WorkflowName=[System.Web.HTTPUtility]::UrlEncode($workflowName)

        if ($workflows.IsPresent) {
            $Parameters.Add('URI',"/$scope/$myself/$PolicyName/workflows/$WorkflowName")
        }
        else {
            $Parameters.Add('URI',"/$scope/$myself/$PolicyName")
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
                if ($workflows.IsPresent -and (!$WorkflowName)) {
                    Write-Output $Result.workflows
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

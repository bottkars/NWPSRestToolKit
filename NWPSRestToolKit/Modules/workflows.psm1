function Get-NWWorkflows {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Get-NSRworkflows')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = "Policy", ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $True, ParameterSetname = "Workflow", ValueFromPipelineByPropertyName = $true)]
        [alias('Policy')]
        $Policyname,
        [Parameter(Mandatory = $True, ParameterSetname = "Workflow", ValueFromPipelineByPropertyName = $true)]
        [alias('Workflow')]
        $Workflowname, 
        [Parameter(Mandatory = $FALSE, ParameterSetname = "Workflow", ValueFromPipelineByPropertyName = $true)]
        
        [switch]$jobgroups,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]$scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        Write-Verbose ( $MyInvocation | Out-String )
        $ContentType = "application/json"
        $Myself = 'protectionpolicies'
        $Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
        $Method = "GET"
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            "Policy" {
                $URI = "/$scope/$myself/$PolicyName/workflows"
            }
            "Workflow" {
                $URI = "/$scope/$myself/$PolicyName/workflows/$WorkflowName"
            }
            Default {
                $URI = "/$scope/$myself"
            }           
        }
        If ($jobgroups.IsPresent) {
            $URI = "$URI/jobgroups"
        }
        $Parameters = @{
            RequestMethod = "REST"
            body          = $body 
            Method        = $Method
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }
        $Parameters.Add('URI', $URI )

   
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
            "Policy" {
                Write-Output $Result.workflows
            }
            "Workflow" {
                If ($jobgroups.IsPresent) {
                    Write-Output $Result.jobs
                }
                else {
                    Write-Output $Result
                }
                
            }
            Default {
                Write-Output $Result.protectionPolicies
            }            
        }

    }
}


Function Start-NWWorkflows {
    [CmdletBinding(DefaultParameterSetName = '1')]
    [Alias('Start-NSRWorkflows')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [alias('PPN')]
        $ProtectionPolicy,
        [Parameter(Mandatory = $true, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [alias('WFN')]
        $WorkflowName,
        [Parameter(Mandatory = $false, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [string[]]$clients,
        [Parameter(Mandatory = $false, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [switch]$restart,
        [Parameter(Mandatory = $false, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [switch]$isAdhoc,        
        [Parameter(Mandatory = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false
            #ValueFromPipeline=$true
        )]
        $tenantid
    )


    Begin {
        $ContentType = "application/json"
        $Myself = ($MyInvocation.MyCommand.Name.Substring(6)).ToLower()
        $Method = "POST"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {

        $Body = @{} 
        if ($Clients) {
            $Body.add('clients', $Clients)
        } 
        $body.Add('restart', $restart.ToString())
        $body.Add('isAdhoc', $isAdhoc.ToString()) 
        $Body = $Body | ConvertTo-Json
        Write-Verbose ( $Body | out-string )
        $Parameters = @{
            RequestMethod           = "REST"
            body                    = $body 
            Method                  = $Method
            Verbose                 = $PSBoundParameters['Verbose'] -eq $true
            URI                     = "$scope/protectionpolicies/$ProtectionPolicy/workflows/$WorkflowName/op/backup"
            ResponseHeadersVariable = "HeaderResponse"       

        }
        #    Write-Verbose ( $Parameters | out-string )
        try {

            $Response = Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        
    }
    end {
        If ($Response.'Location') {
            $JOB = $Response.'Location' | split-path -Leaf 
            Get-NWJobs -id $JOB            
        }

    }
}

Function Set-NWWorkflows {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [alias('Policy', 'PolicyName')]
        $ProtectionPolicy,
        [Parameter(Mandatory = $true, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [alias('Workflow')]
        $WorkflowName,
        [Parameter(Mandatory = $false, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [switch]$enabled,
        [Parameter(Mandatory = $false, ParameterSetname = 1, ValueFromPipelineByPropertyName = $true)]
        [switch]$autoStartEnabled,  
        [Parameter(Mandatory = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false
            #ValueFromPipeline=$true
        )]
        $tenantid
    )


    Begin {
        $ContentType = "application/json"
        $Method = "PUT"
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }
    }
    Process {

        $Body = @{} 

        $body.Add('enabled', $enabled.ToString())
        $body.Add('autoStartEnabled', $autoStartEnabled.ToString()) 
        $Body = $Body | ConvertTo-Json
        Write-Verbose ( $Body | out-string )
        $Parameters = @{
            RequestMethod           = "REST"
            body                    = $body 
            Method                  = $Method
            Verbose                 = $PSBoundParameters['Verbose'] -eq $true
            URI                     = "$scope/protectionpolicies/$ProtectionPolicy/workflows/$WorkflowName"
            ResponseHeadersVariable = "HeaderResponse"       

        }
        #    Write-Verbose ( $Parameters | out-string )
        try {

            $Response = Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
        
    }
    end {
        Write-Output ($Response )
    }
}
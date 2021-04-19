<#
Filesystem
,
SAP HANA
,
SAPOracle
,
SmartSnap
,
Sybase
,
BBB
,
SQL Server
,
Microsoft Exchange Server
,
Data Domain
#>


function New-NWinspect {
    [CmdletBinding(DefaultParameterSetName = '1')]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'WithUser')]
        $Username,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'WithUser')][securestring]
        $password,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]$hostname,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Filesystem',
            'SAP HANA',
            'SAPOracle',
            'SmartSnap',
            'Sybase',
            'BBB',
            'SQL Server',
            'Microsoft Exchange Server',
            'Data Domain')][string]
        $type,        
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        [ValidateSet('global', 'datazone', 'tenant')]
        $scope = "global",
        [Parameter(Mandatory = $false, ValueFromPipeline = $false)]
        $tenantid
    )
    Begin {
        $ContentType = "application/json"
        $Myself = $MyInvocation.MyCommand.Name.Substring(6).ToLower()
        $local:Result = @()
        if ($scope -eq "tenant") {
            $scope = "$scope/$tenantid"
        }

    }
    Process {
        $Method = "POST"
        $Body = @{}
        Switch ($PSCmdlet.ParameterSetName) {
            'WithUser' {
                $Body.Add('userName', $username)
                $Body.Add('password', [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))        
            }
        }
        Switch ($type) {
            default {
                $Uri = "$scope/$myself"
            }
            'Data Domain'
            {
                $Uri = "$scope/$myself/datadomain"

            }
        }
        $Body.Add('hostname', $hostname)
        $Body.Add('type', $type)       
        $Parameters = @{
            body          = $body | ConvertTo-Json
            RequestMethod = "REST"
            Method        = $Method
            Uri           = $uri
            Verbose       = $PSBoundParameters['Verbose'] -eq $true
        }    
        try {
            $local:Result += Invoke-NWAPIRequest @Parameters
        }
        catch {
            Get-NWWebException -ExceptionMessage $_
            return
        }
    }
    End {
        Write-Verbose ($local:Result | Out-String)
        if ($hostname) {
            Write-Output $local:Result
        }
        else {
            Write-Output $local:Result
        }

    }
}


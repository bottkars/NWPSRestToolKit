function Connect-NWServer {
    [CmdletBinding()]
    Param
    (    [CmdletBinding()]

    [Parameter(Mandatory = $true)]
    $NWIP,
    [Parameter(Mandatory = $false)]$NWPort = 9090,
    [Parameter(Mandatory = $false)][pscredential]$Credentials,
    [Parameter(Mandatory = $false)][ValidateSet('v1', 'v2', 'v3')][string]$apiver = "v3",
    [Parameter(Mandatory = $false)][switch]$trustCert,
    [Parameter(Mandatory = $false)][ValidateSet('global', 'datazone', 'tenant')]
    $scope = "global"
    )

    Begin {
        if ($trustCert.IsPresent) {
            if ($($PSVersionTable.PSVersion.Major) -ge 6) {
                $global:SkipCertificateCheck = $TRUE
            }
            else {
                Unblock-NWCerts 
            }

        } 
        $Method = "GET" 
    }
    Process {
        if (!$Credentials) {
            $User = Read-Host -Prompt "Please enter the username for Networker Administrator"
            $SecurePassword = Read-Host -Prompt "Enter Networker Password for user $user" -AsSecureString
            $Global:NWCredentials = New-Object System.Management.Automation.PSCredential (“$user”, $Securepassword)
        }
        $Global:NWbaseurl = "https://$($NWIP):$($NWPort)/nwrestapi/$apiver"
        $Global:NWbaseuri = "https://$($NWIP)"
        $Global:NWPort = $NWPort
        # Building Hash Literal for unified call
        $Parameters = @{
            body    = $body 
            Method  = $Method
            Uri     = "$scope/serverconfig"
            Verbose = $PSBoundParameters['Verbose'] -eq $true
        } 
    }
    End {
        #        try {              
        $Response = Invoke-NWAPIRequest  @Parameters  
        #            }
        Write-Verbose $Response
        Write-Output $Response.Content | ConvertFrom-Json
    }
}



function Connect-NWServerV2 {
    [CmdletBinding()]
    Param
    (    [CmdletBinding()]

    [Parameter(Mandatory = $true)]
    $NWIP,
    [Parameter(Mandatory = $false)]$NWPort = 9090,
    [Parameter(Mandatory = $false)][pscredential]$Credentials,
    [Parameter(Mandatory = $false)][ValidateSet('v1', 'v2', 'v3')][string]$apiver = "v3",
    [Parameter(Mandatory = $false)][switch]$trustCert,
    [Parameter(Mandatory = $false)][ValidateSet('global', 'datazone', 'tenant')]
    $scope = "global"
    )

    Begin {
        if ($trustCert.IsPresent) {
            if ($($PSVersionTable.PSVersion.Major) -ge 6) {
                $global:SkipCertificateCheck = $TRUE
            }
            else {
                Unblock-NWCerts 
            }

        } 
        $Method = "POST" 
    }
    Process {
        if (!$Global:NWCredentials) {
            $User = Read-Host -Prompt "Please enter the username for Networker Administrator"
            $SecurePassword = Read-Host -Prompt "Enter Networker Password for user $user" -AsSecureString
            $Global:NWCredentials = New-Object System.Management.Automation.PSCredential (“$user”, $Securepassword)
        }

        $Headers = @{
            'Token-Type' = "jwt" 
        }
        $Parameters = @{
            Uri             = "https://$($NWIP):$($NWPort)/auth-server/api/sec/authenticate"
            Authentication  = "Basic"
            Credential      = $Global:NWCredentials
            Method          = "POST"
            ContentType     = "Application/Json"
            Verbose         = $PSBoundParameters['Verbose'] -eq $true
            Headers         = $Headers 
            SessionVariable = "SessionVariable"
        }
        if ($Global:SkipCertificateCheck) {
            $Parameters.Add('SkipCertificateCheck', $True)
        }
        Write-Verbose ($Parameters | Out-String)
        $Token = Invoke-RestMethod @Parameters
        $Global:NWHeaders = @{
            'Authorization' = "Bearer $($Token.data.token)" 
        }
        $Global:NWbaseurl = "https://$($NWIP):$($NWPort)"
        $Global:NWbaseuri = "https://$($NWIP)"
        $Global:NWPort = $NWPort
        # Building Hash Literal for unified call
        $Parameters = @{
            body        = $body 
            Method      = "GET"
            Uri         = "$scope/serverconfig"
            Verbose     = $PSBoundParameters['Verbose'] -eq $true
            ContentType = "Application/Json"
        } 
    }
    End {
        $Response = Invoke-NWAPIRequest @Parameters  
        Write-Verbose $Response
        Write-Output $Response.Content | ConvertFrom-Json
    }
}
function Unblock-NWCerts {
    Add-Type -TypeDefinition @"
	    using System.Net;
	    using System.Security.Cryptography.X509Certificates;
	    public class TrustAllCertsPolicy : ICertificatePolicy {
	        public bool CheckValidationResult(
	            ServicePoint srvPoint, X509Certificate certificate,
	            WebRequest request, int certificateProblem) {
	            return true;
	        }
	    }
"@ -ErrorAction SilentlyContinue
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
}
function Get-NWyesno {
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
        SupportsShouldProcess = $true, 
        PositionalBinding = $false,
        HelpUri = 'http://labbuildr.com/',
        ConfirmImpact = 'Medium')]
    Param
    (
        $title = "Delete Files",
        $message = "Do you want to delete the remaining files in the folder?",
        $Yestext = "Yestext",
        $Notext = "notext"
    )
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "$Yestext"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "$Notext"
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
    $result = $host.ui.PromptForChoice($title, $message, $options, 0)
    return ($result)
}


function Invoke-NWAPIRequest {
    [CmdletBinding(HelpUri = "")]
    #[OutputType([int])]
    Param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $uri,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        [ValidateSet('Get', 'Delete', 'Put', 'Post', 'Patch')]
        $Method,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $Query,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $ContentType = 'application/json', 
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('v1', 'v2', 'v3')]
        $apiver = "v3",
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $ResponseHeadersVariable,            
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $apiport = "$($Global:NWPORT)",        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $NW_BaseUri = $($Global:NW_BaseUri),
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('Rest', 'Web')]$RequestMethod,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $API="nwrestapi/$apiver",       
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Body,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Headers = @{},        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Filter,
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $InFile
    )
    $uri = "$($Global:NWBaseUri):$apiport/$API/$($uri.trimStart('/'))"
    $uri = $uri.TrimEnd('/')
    if ($Global:NWCredentials) {
        $CallHeaders = $Global:NWHeaders
        $CallHeaders += $Headers
        Write-Verbose ($CallHeaders | Out-String)
        Write-Verbose "==> Calling $uri"
        $Parameters = @{
            UseBasicParsing = $true 
            Method          = $Method
            Headers         = $CallHeaders
            ContentType     = $ContentType
#            Credential      = $NWCredentials
        }
        switch ($PsCmdlet.ParameterSetName) {    
            'infile' {
                $Parameters.Add('InFile', $InFile) 
            }
            default {
                if ($Body) {
                    $Parameters.Add('body', $body)
                    Write-Verbose $body | Out-String

                }
                if ($query) {
                    $Parameters.Add('body', $query)
                    Write-Verbose $Query | Out-String
                }
                if ($filter) {
                    $filterstring = [System.Web.HTTPUtility]::UrlEncode($filter)
                    $filterstring = "filter=$filterstring"
                    Write-Verbose $filterstring | Out-String
                    $uri = "$($uri)?$filterstring"
                    Write-Verbose $uri
                }
                if ($ResponseHeadersVariable) {
                    $Parameters.Add('ResponseHeadersVariable', 'HeadersResponse')
                }

            }
        }
        $Parameters.Add('URI', $uri)
        if ($Global:SkipCertificateCheck) {
            $Parameters.Add('SkipCertificateCheck', $True)
        }
        Write-Verbose ( $Parameters | Out-String )    
        try {
            switch ($RequestMethod) {
                'Web' {
                    $Result = Invoke-WebRequest @Parameters
                }
                'Rest' {
                
                    $Result = Invoke-RestMethod @Parameters
                }
                default {
                    $Result = Invoke-WebRequest @Parameters
                }
            }
        
        }
        catch {
            # Write-Warning $_.Exception.Message
            Get-NWWebException -ExceptionMessage $_
            Break
        }
    }
    else {
        Write-Warning "NW_Headers are not present. Did you connect to NW  using Connect-NWserver ? "
        break
    }
    if ($ResponseHeadersVariable) {
        Write-Output $HeadersResponse 
    }
    else {
        Write-Output $Result
    }
    
}
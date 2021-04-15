function Connect-NWServer {
    [CmdletBinding()]
    Param
    (    [CmdletBinding()]

        [Parameter(Mandatory = $true)]
        $NWIP,
        [Parameter(Mandatory = $false)]$NWPort = 9090,
        [Parameter(Mandatory = $false)][pscredential]$Credentials,
        [Parameter(Mandatory = $false)][ValidateSet('v1', 'v2', 'v3')][string]$apiver = "v3",
        [Parameter(Mandatory = $false)][switch]$trustCert
    )

    Begin {
        if ($trustCert.IsPresent) {
            Unblock-NWCerts
        }  
    }
    Process {
        if (!$Credentials) {
            $User = Read-Host -Prompt "Please enter the username for Networker Administrator"
            $SecurePassword = Read-Host -Prompt "Enter Networker Password for user $user" -AsSecureString
            $Global:NWCredentials = New-Object System.Management.Automation.PSCredential (“$user”, $Securepassword)
        }
        $Global:NWbaseurl = "https://$($NWIP):$($NWPort)/nwrestapi/$apiver"
        $Global:NWbaseuri = "https://$($NWIP)"
        $Global_NWPort = $NWPort
    }
    End {
        Get-NWserverconfig | select name, serverOSType
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
"@
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


function invoke-NWAPIRequest {
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
        $apiport = "$($Global:NWPORT)",        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        $NW_BaseUri = $($Global:NW_BaseUri),
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'infile')]
        [ValidateSet('Rest', 'Web')]$RequestMethod,        
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Body,
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        $Filter,
        [Parameter(Mandatory = $true, ParameterSetName = 'infile')]
        $InFile
    )
    $uri = "$($Global:NWBaseUri):$apiport/nwrestapi/$apiver/$uri"
    if ($Global:NWCredentials) {
        # $Headers = $Global:NW_Headers
        Write-Verbose ($Headers | Out-String)
        Write-Verbose "==> Calling $uri"
        $Parameters = @{
            UseBasicParsing = $true 
            Method          = $Method
            #        Headers         = $Headers
            ContentType     = $ContentType
            Credential     = $NWCredentials
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

    Write-Output $Result
}
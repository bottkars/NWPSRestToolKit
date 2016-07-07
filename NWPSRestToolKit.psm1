function Connect-NWServer
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $NWIP = "192.168.2.11",
        $NWPort = 9090,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)][pscredential]$Credentials,

        [switch]$trustCert
    )

    Begin
    {
    if ($trustCert.IsPresent)
        {
        Unblock-NWCerts
        }  
    }
    Process
    {
    if (!$Credentials)
        {
        $User = Read-Host -Prompt "Please enter the username for Networker Administrator"
        $SecurePassword = Read-Host -Prompt "Enter Networker Password for user $user" -AsSecureString
        $Global:NWCredentials = New-Object System.Management.Automation.PSCredential (“$user”,$Securepassword)
        }
    $Global:NWbaseurl = "https://$($NWIP):$($NWPort)/nwrestapi/v1"
    }
    End
    {
    Get-NWserverconfig | select name,serverOSType
    }
}
function Unblock-NWCerts
{
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
function Get-NWyesno
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://labbuildr.com/',
                  ConfirmImpact='Medium')]
    Param
    (
$title = "Delete Files",
$message = "Do you want to delete the remaining files in the folder?",
$Yestext = "Yestext",
$Notext = "notext"
    )
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","$Yestext"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","$Notext"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
return ($result)
}
<#
function Get-NWserverSession
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = "serverconfig"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself"
    $MethodType = 'GET'
    try
        {
        Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType  -SessionVariable nwserversession #.$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
    catch
        {
        Get-NWWebException -ExceptionMessage $_
        return
        }
    $Global:nwserversession = $nwserversession
    }
    End
    {

    }
}
#>

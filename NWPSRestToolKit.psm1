function Connect-NW
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $global:NWIP = "192.168.2.11",
        $global:NWPort = 9090,
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
        $User = Read-Host -Prompt "Please Enter NW username"
        $SecurePassword = Read-Host -Prompt "Enter NW Password for user $user"# -AsSecureString
        }
    $pass = $SecurePassword
    $pair = "$($user):$($SecurePassword)"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"
    $Global:Headers = @{
        'Content-Type' = 'application/json'
        Authorization = $basicAuthValue
        }
    $Global:NWbaseurl = "https://$($NWIP):$($NWPort)/nwrestapi/v1"

    }
    End
    {
    }
}

function Get-NWbackups
{
    [CmdletBinding(DefaultParameterSetName='1')]
    Param
    (
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
    $Method = 'global/backups'
    $MethodType = 'GET'
    $jsonbody = ConvertTo-Json $body
    try
        {
        (Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Headers $global:Headers -ContentType $ContentType -Verbose).backups | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
        }
    catch
        {
        $_.Exception.Message
        break
        }
    }
    End
    {

    }
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
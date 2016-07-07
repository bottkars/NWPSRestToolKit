function Remove-NWclient
{
    [CmdletBinding(DefaultParameterSetName = '1',
                        SupportsShouldProcess=$true, 
                        ConfirmImpact='Medium')]
    Param
    (
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true
                   )]#[alias('ID')]
    $ClientResourceID,
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false,
                   ValueFromPipeline=$false
                   )]
    $tenantid
    )
    Begin
    {
    $ContentType = "application/json"
    $Myself = $MyInvocation.MyCommand.Name.Substring(9) + "s"
    if ($scope -eq "tenant")
        {
        $scope = "$scope/$tenantid"
        }
    }
    Process
    {
    $Method = "$scope/$Myself/$ClientResourceID"
    $MethodType = 'DELETE'
    if ($ConfirmPreference -match "none")
        { 
        $commit = 1 
        }
    else
        {
        $commit = Get-NWyesno -title "commit $Myself deletion" -message "this will delete client $ClientResourceID"
        }
    Switch ($commit)
        {
        1
            {
            try
                {
                $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint("$NWbaseurl/$Method") 
                Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -TimeoutSec 10 #) #.$Myself | Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientResourceID";E={$_.id}} -ExcludeProperty ID # @{N="$($Myself)Name";E={$_.ID}} #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                $ServicePoint.CloseConnectionGroup("") | Out-Null
                }
            catch
                {
                Get-NWWebException -ExceptionMessage $_
                return
                }
            Write-Host "Client with ID $ClientResourceID removed"
            }
        0
            {
            Write-Warning "deletion  refused by user for $Myself $ClientResourceID"
            }
        }      
    
    }
    End
    {

    }
}
function Remove-NWclient
{
    [CmdletBinding(DefaultParameterSetName = '1',
                        SupportsShouldProcess=$true, 
                        ConfirmImpact='Medium')]

    Param
    (
    [Parameter(Mandatory=$true,Position = 0,
                   ValueFromPipelineByPropertyName=$true
                   )][alias('Clientid')]
    $ClientRessourceID,
    [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
                   )]
    [ValidateSet('global','datazone','tenant')]$scope = "global",
    [Parameter(Mandatory=$false
                   #ValueFromPipeline=$true
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
    $Method = "$scope/$Myself/$ClientRessourceID"
    $MethodType = 'DELETE'
    if ($ConfirmPreference -match "none")
        { 
        $commit = 1 
        }
    else
        {
        $commit = Get-NWyesno -title "commit $Myself deletion" -message "this will delete client $ClientRessourceID"
        }
    Switch ($commit)
        {
        1
            {
            try
                {
                if ($id)
                    {
                    Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -TimeoutSec 10 # ) #| Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientRessource";E={$_.id}} -ExcludeProperty ID # .$Myself | Select-Object * -ExcludeProperty links #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                    }
                else
                    {
                    Invoke-RestMethod -Uri "$NWbaseurl/$Method" -Method $MethodType -Credential $NWCredentials -ContentType $ContentType -TimeoutSec 10 #) #.$Myself | Select-Object *,@{N="clientGUID";E={$_.clientid}} -ExcludeProperty ClientID | Select-Object * -ExcludeProperty links,ID,resourceID -ExpandProperty resourceID | Select-Object *,@{N="ClientRessourceID";E={$_.id}} -ExcludeProperty ID # @{N="$($Myself)Name";E={$_.ID}} #| Select-Object -ExpandProperty attributes #-ExpandProperty attributes #@{N="$($Myself)Name";E={$_.name}},
                    }

                }
            catch
                {
                Get-NWWebException -ExceptionMessage $_
                return
                }
            Write-Host "Client with ID $ClientRessourceID removed"
            }
        0
            {
            Write-Warning "deletion  refused by user for $Myself $ClientRessourceID"
            }
        }      
    
    }
    End
    {

    }
}
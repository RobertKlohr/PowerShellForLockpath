#FIXME rework from set-auth to get-auth so we can get invoke-lockpathRest working with auth
#TODO remove the session only switch and Code
#TODO rename to Get-LockpathCredential
function Get-LockpathAuthentication {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param(
        [string] $Path,

        [switch] $SessionOnly
    )

    Write-InvocationLog

    $Credential = Read-Credential -Path $Path

    #TODO if $credential is null then run set-auth
    if ([String]::IsNullOrWhiteSpace($Credential.GetNetworkCredential().Password)) {
        $message = "The password was not provided in the password field."
        Write-Log -Message $message -Level Error
        throw $message
    }

    if (-not $SessionOnly) {
        $message = $message + '***The Username and Password are being cached across PowerShell sessions.  To clear caching, call Clear-LockpathAuthentication.***'
    }

    return $Credential
}

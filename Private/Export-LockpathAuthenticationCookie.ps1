function Export-LockpathAuthenticationCookie {
    <#
    .SYNOPSIS
        Attempts to export the API authentication cookie to the local file system.

    .DESCRIPTION
        Attempts to export the API authentication cookie to the local file system.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER CookieCollection
        A .Net cookie collection.

    .PARAMETER Uri
        Uri of the cookie.

    .EXAMPLE
        Export-LockpathAuthenticationCookie

    .INPUTS
        System.Net.CookieCollection

    .OUTPUTS
        None

    .NOTES
        Private helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(
            Mandatory = $true)]
        [System.Net.CookieCollection] $CookieCollection,

        [Parameter(
            Mandatory = $true)]
        [String] $Uri
    )

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
    }
    # FIXME check to see if this section can be deleted
    # $Script:LockpathConfig.authenticationCookie = [Hashtable] @{
    #     'Domain' = $webSession.Cookies.GetCookies($uri).Domain
    #     'Name'   = $webSession.Cookies.GetCookies($uri).Name
    #     'Value'  = $webSession.Cookies.GetCookies($uri).Value
    # }

    $Script:LockpathConfig.authenticationCookie = [Hashtable] @{
        'Domain' = $CookieCollection.GetCookies($uri).Domain
        'Name'   = $CookieCollection.GetCookies($uri).Name
        'Value'  = $CookieCollection.GetCookies($uri).Value
    }

    try {
        Export-Clixml -InputObject $Script:LockpathConfig.authenticationCookie -Path $Script:LockpathConfig.authenticationCookieFilePath -Depth 10 -Force
        $message = 'success'
    } catch {
        $message = 'failed'
        $level = 'Warning'
    } finally {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
    }
}

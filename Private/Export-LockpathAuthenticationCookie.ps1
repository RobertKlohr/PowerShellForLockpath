# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

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
        SupportsShouldProcess = $true
    )]

    [OutputType([System.Void])]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [System.Net.CookieCollection] $CookieCollection
    )

    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PrivateHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = "Executing cmdlet: $functionName"
        'Service'      = $service
        'Result'       = "Executing cmdlet: $functionName"
    }

    Write-LockpathInvocationLog @logParameters -RedactParameter 'CookieCollection'

    # TODO check to see if this section can be deleted
    $Script:LockpathConfig.authenticationCookie = [Hashtable] @{
        'Domain' = $CookieCollection.Domain
        'Name'   = $CookieCollection.Name
        'Value'  = $CookieCollection.Value
    }

    $shouldProcessTarget = 'Exporting Authentication Cookie'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            Export-Clixml -InputObject $Script:LockpathConfig.authenticationCookie -Path $Script:LockpathConfig.authenticationCookieFilePath -Depth $Script:LockpathConfig.conversionDepth -Force
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
    }
}


# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Remove-LockpathCredential {
    <#
    .SYNOPSIS
        Allows the user to remove the API credential used for authentication.

    .DESCRIPTION
        Allows the user to remove the API credential used for authentication.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER SessionOnly
        Removes the API credential from the session and does not delete the credential stored in the local file.

    .EXAMPLE
        Set-LockpathCredential

        Removes the API credential from the session AND deletes the credential from the local file.

    .EXAMPLE
        Set-LockpathCredential -SessionOnly

        Removes the API credential from the session.

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Public helper method.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Switch] $SessionOnly
    )

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    $logParameters = [ordered]@{
        'Confirm'      = $false
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
        'WhatIf'       = $false
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = 'Cleared API credential (websession) from memory.'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        $Script:LockpathConfig.credential = $null
        $Script:LockpathConfig.webSession = $null
        $logParameters.Message = 'Success: ' + $shouldProcessTarget
        if (-not $SessionOnly) {
            $shouldProcessTarget = "Cleared API credential from the session and $($Script:LockpathConfig.credentialFilePath) from the file system."
            try {
                Remove-Item -Path $Script:LockpathConfig.credentialFilePath -Force
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
        }
        return $logParameters.Message
    }
}

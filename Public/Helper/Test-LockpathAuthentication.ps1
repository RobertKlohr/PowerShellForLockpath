# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Test-LockpathAuthentication {
    <#
    .SYNOPSIS
        Tests if the authentication cookie stored in the configuration is valid. If not tries to authenticate and
        set a new cookie.

    .DESCRIPTION
        Tests if the authentication cookie stored in the configuration is valid. If not tries to authenticate and
        set a new cookie.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Test-LockpathAuthentication

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
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param()

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

    $shouldProcessTarget = 'Testing Authentication'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            Send-LockpathPing
            $logParameters.Message = 'success'
        } catch {
            Connect-Lockpath
            $message = 'failed'
            $level = 'Warning'
        } finally {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
        }
        return $logParameters.Message
    }
}

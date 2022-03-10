# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Test-LockpathApiSession {
    <#
    .SYNOPSIS
        Tests if the authentication cookie stored in the configuration is valid. If not tries to authenticate and set a new cookie.

    .DESCRIPTION
        Tests if the authentication cookie stored in the configuration is valid. If not tries to authenticate and set a new cookie.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .EXAMPLE
        Test-LockpathApiSession

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
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = $null
        'Service'      = $service
        'Result'       = $null
    }

    Write-LockpathInvocationLog @logParameters

    $shouldProcessTarget = 'Testing Authentication'

    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        try {
            Send-LockpathPing
            $logParameters.Message = 'Success: ' + $shouldProcessTarget
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = 'Failed: ' + $shouldProcessTarget
            $logParameters.Result = $_.Exception.Message
        } finally {
            Write-LockpathLog @logParameters
        }
        return $result
    }
}

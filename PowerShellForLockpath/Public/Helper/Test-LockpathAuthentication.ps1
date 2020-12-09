function Test-LockpathAuthentication {
    <#
    .SYNOPSIS
        Tests if the authentication cookie stored in the configuration is a valid. If not tries to authenticate and
        set a new cookie.

    .DESCRIPTION
        Tests if the authentication cookie stored in the configuration is a valid. If not tries to authenticate and
        set a new cookie.

        Calls Send-LockpathPing and returns either returns true or calls Send-LockpathLogin and then returns either
        true or false.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Test-LockpathAuthentication

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Public helper method.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    $service = 'PublicHelper'

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

    if ($PSCmdlet.ShouldProcess("Test API authentication:  $($Script:LockpathConfig.instanceName)", $($Script:LockpathConfig.instanceName), 'Test API authentication:')) {
        if (Send-LockpathPing) {
            return $true
        } elseif (Send-LockpathPing) {
            return $true
        } else {
            return $false
        }
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -FunctionName $functionName -Level $level -Service $service
    }
}

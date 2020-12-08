function Get-LockpathComponentList {
    <#
    .SYNOPSIS
        Returns a complete list of all components.

    .DESCRIPTION
        Returns a complete list of all components available to the user based on account permissions. No input
        elements are used. The list will be ordered in ascending alphabetical order of the component name.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Get-LockpathComponentList

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetComponentList

        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service ComponentService

    $params = @{
        'UriFragment' = 'ComponentService/GetComponentList'
        'Method'      = 'GET'
        'Description' = 'Getting component list.'
    }

    if ($PSCmdlet.ShouldProcess('Getting component list.', '', 'Getting component list.')) {
        [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'ShouldProcess confirmation was denied.' -Level Verbose -FunctionName ($PSCmdlet.CommandRuntime.ToString()) -Service ComponentService
    }
}

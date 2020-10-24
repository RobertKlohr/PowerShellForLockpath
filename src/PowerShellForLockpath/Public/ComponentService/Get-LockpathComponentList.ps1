function Get-LockpathComponentList {
    <#
    .SYNOPSIS
        Returns a complete list of all components.

    .DESCRIPTION
        Returns a complete list of all components available to the user based on account permissions. No input
        elements are used. The list will be ordered in ascending alphabetical order of the component name.

    .EXAMPLE
        Get-LockpathComponentList

    .INPUTS
        None.

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $params = @{
        'UriFragment' = 'ComponentService/GetComponentList'
        'Method'      = 'GET'
        'Description' = "Getting component list."
    }

    if ($PSCmdlet.ShouldProcess("Getting component list.", '', 'Getting component list.')) {
        $result = Invoke-LockpathRestMethod @params -Confirm:$false
        return $result
    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
    }
}

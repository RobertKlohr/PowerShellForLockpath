function Get-LockpathComponentByAlias {
    <#
    .SYNOPSIS
        Returns available fields for a given component.

    .DESCRIPTION
        Returns available fields for a given component. A component is a user-defined data object such as a custom
        content table. The component alias may be found by using Get-LockpathComponentList.

    .PARAMETER ComponentAlias
        Specifies the system alias of the component as a string.

    .EXAMPLE
        Get-LockpathComponentByAlias -ComponentAlias 'Controls'

    .EXAMPLE
        Get-LockpathComponentByAlias 'Controls'

    .EXAMPLE
        'Controls' | Get-LockpathComponentByAlias

    .EXAMPLE
        'Controls', 'AuthorityDocs', 'AwarenessEvents' | Get-LockpathComponentByAlias

    .EXAMPLE
        $componentObject | Get-LockpathComponentByAlias
        If $componentObject has an property called ComponentAlias that value is automatically passed as a parameter.

    .INPUTS
        System.String

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

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Alias")]
        [ValidateLength(1, 256)]
        [string] $ComponentAlias
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetComponentByAlias?alias=$ComponentAlias"
            'Method'      = 'GET'
            'Description' = "Getting component with alias: $ComponentAlias"
        }
        if ($PSCmdlet.ShouldProcess("Getting component with alias: $([environment]::NewLine) $ComponentAlias", $ComponentAlias, 'Getting component with alias:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

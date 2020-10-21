function Get-LockpathWorkflows {
    <#
.SYNOPSIS
    Retrieves all workflows for a component specified by its Alias.
.DESCRIPTION
    Retrieves all workflows for a component specified by its Alias. A component is a user-defined data object such
    as a custom content table. The component Alias may be found by using GetComponentList (ShortName).
.PARAMETER ComponentAlias
    Specifies the system alias of the component as a string.
.EXAMPLE
    Get-LockpathWorkflows -ComponentAlias 'Controls'
.EXAMPLE
    Get-LockpathWorkflows 'Controls'
.EXAMPLE
    'Controls' | Get-LockpathWorkflows
.EXAMPLE
    'Controls', 'AuthorityDocs', 'AwarenessEvents' | Get-LockpathWorkflows
.EXAMPLE
    $workflowObject | Get-LockpathWorkflows
    If $workflowObject has an property called ComponentAlias that value is automatically passed as a parameter.
.INPUTS
    System.String.
.OUTPUTS
    System.String.
.NOTES
    The authentication account must have Read Administrative Access permissions for the specific component.
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
        #TODO determine what the actual maximum length is for this attribute.  75 was largest found.
        [ValidateLength(1, 256)]
        [string] $ComponentAlias
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetWorkflows?componentalias=$ComponentAlias"
            'Method'      = 'GET'
            'Description' = "Getting workflows with component alias: $ComponentAlias"
        }
        if ($PSCmdlet.ShouldProcess("Getting workflows with component alias: $([environment]::NewLine) $ComponentAlias", $ComponentAlias, 'Getting workflows with component alias:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

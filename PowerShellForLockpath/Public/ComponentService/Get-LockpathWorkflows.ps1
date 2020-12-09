function Get-LockpathWorkflows {
    <#
    .SYNOPSIS
        Retrieves all workflows for a component specified by its Alias.

    .DESCRIPTION
        Retrieves all workflows for a component specified by its Alias. A component is a user-defined data object
        such as a custom content table. The component Alias may be found by using GetComponentList (ShortName).

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

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
        String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetWorkflows?componentalias=$ComponentAlias

        The authentication account must have Read Administrative Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
        [ValidateLength(1, 128)]
        [String] $ComponentAlias
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    # TODO add ability to lookup by component Id as well as alias

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Workflows By Component Alias'
            'Method'      = 'GET'
            'Query'       = "?ComponentAlias=$ComponentAlias"
            'Service'     = $service
            'UriFragment' = 'GetWorkflows'
        }

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } else {
                return $result
            }
        }
    }

    end {
    }
}

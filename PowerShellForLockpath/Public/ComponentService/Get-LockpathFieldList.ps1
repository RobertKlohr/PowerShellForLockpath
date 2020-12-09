function Get-LockpathFieldList {
    <#
    .SYNOPSIS
        Returns detail field listing for a given component.

    .DESCRIPTION
        Returns detail field listing for a given component. A component is a user-defined data object such as a
        custom content table. The component Id may be found by using Get-LockpathComponentList. Assessments field
        type are not visible in this list.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .EXAMPLE
        Get-LockpathFieldList -ComponentId 2

    .EXAMPLE
        Get-LockpathFieldList 2

    .EXAMPLE
        2 | Get-LockpathFieldList

    .EXAMPLE
        2,3,6 | Get-LockpathFieldList

    .EXAMPLE
        $componentObject | Get-LockpathFieldList
        If $componentObject has an property called ComponentId that value is automatically passed as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetFieldList?componentId=$ComponentId

        The authentication account must have Read General Access permissions for the specific component.

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
        [ValidateRange('Positive')]
        [Int64] $ComponentId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Field List By Component Id'
            'Method'      = 'GET'
            'Query'       = "?ComponentId=$ComponentId"
            'Service'     = $service
            'UriFragment' = 'GetFieldList'
        }

        $target = "ComponentId=$ComponentId"

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

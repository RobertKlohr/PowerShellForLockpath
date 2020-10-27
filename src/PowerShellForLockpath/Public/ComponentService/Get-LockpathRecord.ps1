function Get-LockpathRecord {
    <#
    .SYNOPSIS
        Returns the complete set of fields for a given record within a component.

    .DESCRIPTION
        Returns the complete set of fields for a given record within a component. The component Id may be found by
        using Get-LockpathComponentList. The record Id may be found by using Get-LockpathRecords.

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer.

    .PARAMETER RecordId
        Specifies the Id number of the record as a positive integer.

    .EXAMPLE
        Get-LockpathRecord -ComponentId 2 -RecordId 1

    .INPUTS
        System.Uint32

    .OUTPUTS
        System.String

    .NOTES
        The authentication account must have Read General Access permissions for the specific component, record and
        field.

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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Component")]
        [ValidateRange("Positive")]
        [uint] $ComponentId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("Record")]
        [ValidateRange("Positive")]
        [uint] $RecordId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecord?componentId=$ComponentId&recordId=$RecordId"
            'Method'      = 'GET'
            'Description' = "Getting record with component Id: $ComponentId & record Id: $RecordId"
        }

        if ($PSCmdlet.ShouldProcess("Getting record with: $([environment]::NewLine) component Id $ComponentId & record Id: $RecordId", "component Id $ComponentId & record Id: $RecordId", 'Getting record with:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

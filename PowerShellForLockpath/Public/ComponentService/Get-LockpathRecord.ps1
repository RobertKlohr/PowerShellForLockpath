function Get-LockpathRecord {
    <#
    .SYNOPSIS
        Returns the complete set of fields for a given record within a component.

    .DESCRIPTION
        Returns the complete set of fields for a given record within a component. The component Id may be found by
        using Get-LockpathComponentList. The record Id may be found by using Get-LockpathRecords.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .EXAMPLE
        Get-LockpathRecord -ComponentId 2 -RecordId 1

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetRecord?componentId=$ComponentId&recordId=$RecordId

        The authentication account must have Read General Access permissions for the specific component, record and
        field.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $ComponentId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $RecordId
    )

    begin {
        Write-LockpathInvocationLog -Service ComponentService
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetRecord?componentId=$ComponentId&recordId=$RecordId"
            'Method'      = 'GET'
            'Description' = "Getting record with component Id: $ComponentId & record Id: $RecordId"
        }

        if ($PSCmdlet.ShouldProcess("Getting record with: $([environment]::NewLine) component Id $ComponentId & record Id: $RecordId", "component Id $ComponentId & record Id: $RecordId", 'Getting record with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Service ComponentService
        }
    }

    end {
    }
}

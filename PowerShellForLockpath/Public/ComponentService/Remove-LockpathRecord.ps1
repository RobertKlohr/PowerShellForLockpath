function Remove-LockpathRecord {
    <#
    .SYNOPSIS
        Deletes a record.

    .DESCRIPTION
        Deletes a record. This is a soft delete that hides the record from the user interface and API by changing the
        permissions on the record. To undelete a record requires a support request.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component.

    .PARAMETER RecordId
        Specifies the Id number of the record.

    .EXAMPLE
        Remove-LockpathRecord -ComponentId 6 -RecordId 1

    .EXAMPLE
        $recordObject | Remove-LockpathRecord
        If $recordObject has an property called ComponentId and RecordId those values are automatically passed as parameters.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/DeleteRecord

        The authentication account must have Read and Delete General Access permissions to component and Read
        permissions to the record.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
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
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = 'ComponentService/DeleteRecord'
            'Method'      = 'DELETE'
            'Description' = "Deleting record with Id: $RecordId from component with Id: $ComponentId"
            'Body'        = @{
                'componentId' = $ComponentId
                'recordId'    = $RecordId
            } | ConvertTo-Json -Depth $Script:LockpathConfig.jsonConversionDepth -Compress
        }

        if ($PSCmdlet.ShouldProcess("Deleting record with: $([environment]::NewLine) record Id: $RecordId from component Id: $ComponentId", "record Id: $RecordId from component Id: $ComponentId", 'Deleting record with:')) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

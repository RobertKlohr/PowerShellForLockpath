function Get-LockpathFieldLookupReportColumns {
    <#
    .SYNOPSIS
        Gets the field information of each field in a field path that corresponds to a lookup report column.

    .DESCRIPTION
        Gets the field information of each field in a field path that corresponds to a lookup report column. The
        lookupFieldId corresponds to a lookup field with a report definition on it and the fieldPathId corresponds
        to the field path to retrieve fields from, which is obtained from Get-LockpathRecordDetail.
        Get-LockpathFieldLookupReportColumns compliments Get-LockpathRecordDetail by adding additional details
        about the lookup report columns returned from Get-LockpathRecordDetail.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER FieldId
        Specifies the Id number of the field.

    .PARAMETER FieldPathId
        Specifies the Id number of the field path.

    .EXAMPLE
        Get-LockpathFieldLookupReportColumns -FieldId 2 -FieldPathId 3

    .EXAMPLE
        $fieldLookupObject | Get-LockpathFieldLookupReportColumns
        If $fieldLookupObject has an property called FieldId and FieldPathId the values are automatically passed
        as a parameter.

    .INPUTS
        System.UInt32

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/GetLookupReportColumnFields?lookupFieldId=$FieldId&fieldPathId=$FieldPathId

        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://git.io/powershellforlockpathhelp
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
        [Int64] $FieldId,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $FieldPathId
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Description' = 'Getting Lookup Report Column Fields By Field Id & Field Path'
            'Method'      = 'GET'
            'Query'       = "?LookupFieldId=$FieldId&FieldPathId=$FieldPathId"
            'Service'     = $service
            'UriFragment' = 'GetLookupReportColumnFields'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "LookupFieldId=$FieldId & FieldPathId=$FieldPathId"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}

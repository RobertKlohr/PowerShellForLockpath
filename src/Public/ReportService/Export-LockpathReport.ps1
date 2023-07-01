# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Export-LockpathReport {
    <#
    .SYNOPSIS
        Returns a report for a given report Id.

    .DESCRIPTION
        Returns a report for a given report Id.

        Any filter applied to the report is retained for all reports except a chart report where only the grid report exports.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ReportId
        Specifies the Id number of the report.

    .PARAMETER FileType
        Specifies the file format by specifying the file extension.

    .EXAMPLE
        Export-LockpathReport -ReportId 2642 -FileType csv

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        application/octet-stream

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ReportService/ExportReport?id=[Id]&fileExtension=[FileExtension]

        The authentication account must have Read General Access and Print/Export General Access permissions to the records in the and be the account that created the report.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $ReportId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('csv', 'xlsx', 'pdf')]
        [String] $FileType
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ReportService'

        $logParameters = [ordered]@{
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        $restParameters = [ordered]@{
            'Description' = "Exporting Report with Report Id $ReportId and File Type $FileType"
            'Method'      = 'GET'
            'Query'       = "?id=$ReportId&fileExtension=$FileType"
            'Service'     = $service
            'UriFragment' = 'ExportReport'
        }

        $shouldProcessTarget = $restParameters.Description

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
                try {
                    $logParameters.Result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.Result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}

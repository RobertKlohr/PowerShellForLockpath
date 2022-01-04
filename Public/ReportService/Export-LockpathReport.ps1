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
        SupportsShouldProcess = $true)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    [OutputType('application/octet-stream')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange('Positive')]
        [Int64] $ReportId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('csv', 'xlsx', 'pdf')]
        [String] $FileType
    )

    begin {
        $service = 'ReportService'

        $logParameters = [ordered]@{
            'FunctionName' = ($PSCmdlet.CommandRuntime.ToString())
            'Level'        = 'Information'
            'Service'      = $service
        }
    }

    process {
        # if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
        #     Write-LockpathInvocationLog @logParameters
        # }
        Write-LockpathInvocationLog

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
                $result = Invoke-LockpathRestMethod @restParameters
            } catch {
                if ($null -eq $_.ErrorDetails) {
                    $result = $_.Exception.Message
                } else {
                    $result = ($_.ErrorDetails.Message | ConvertFrom-Json).Message
                }
                $logParameters.Message = $result
                $logParameters.Level = 'Warning'
            } finally {
                if ($Script:LockpathConfig.loggingLevel -in 'Debug', 'Verbose') {
                    Write-LockpathLog @logParameters
                }
            }
            return $result
        }
    }

    end {
    }
}

function Get-LockpathReport {
    <#
    .SYNOPSIS
        Returns a report for a given report Id.

    .DESCRIPTION
        Returns a report for a given report Id.

        Any filter applied to the report is retained for all reports except a chart report where only the grid report exports.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ReportId
        Specifies the Id number of the report.

    .PARAMETER FileType
        Specifies the file format by specifying the file extension.

    .PARAMETER FilePath
        If provided saves the report to disk at the specified path.

    .EXAMPLE
        Get-LockpathReport -ReportId 2642 -FileType CSV

    .EXAMPLE
        Get-LockpathReport -ReportId 2642 -FileType CSV -FilePath 'c:\temp\report.csv'

    .INPUTS
        String, System.UInt32

    .OUTPUTS
        System.Array

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ReportService/ExportReport?id=$ReportId&fileExtension=$FileType

        The authentication account must have Read General Access and Print/Export General Access permissions to the
        report.

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
        [Int64] $ReportId,

        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('csv', 'xlsx', 'pdf')]
        [String] $FileType,

        [System.IO.FileInfo] $FilePath
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ReportService'
    }

    process {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service

        $params = @{
            'Description' = 'Getting Report'
            'Method'      = 'GET'
            'Query'       = "?id=$ReportId&fileExtension=$FileType"
            'Service'     = $service
            'UriFragment' = 'ExportReport'
        }

        $target = "Id=$ReportId"

        # TODO determine if we are going to provide file save function here or just return bytes

        if ($PSCmdlet.ShouldProcess($target)) {
            try {
                # [byte[]]  $result = Invoke-LockpathRestMethod @params
                # if ($null -ne $FilePath) {
                #     Set-Content -Path $FilePath -AsByteStream -Value $result
                # } else {
                #     return $result
                # }
                $result = Invoke-LockpathRestMethod @params
                $message = 'success'
            } catch {
                $message = 'failed'
                $level = 'Warning'
            }
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $message -FunctionName $functionName -Level $level -Service $service
            If ($message -eq 'failed') {
                return $message
            } elseif ($null -ne $FilePath) {
                Set-Content -Path $FilePath -AsByteStream -Value $result
            } else {
                return $result
            }
        }
    }

    end {
    }
}

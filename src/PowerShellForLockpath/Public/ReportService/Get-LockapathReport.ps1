function Get-LockpathReport {
    <#
    .SYNOPSIS
        Returns a report for a given report Id.

    .DESCRIPTION
        Returns a report for a given report Id.

        Filters applied are retained for all reports except a chart report where only the grid exports.

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
        System.String, System.Uint32

    .OUTPUTS
        System.Array

    .NOTES
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
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Report', 'Id')]
        [ValidateRange('Positive')]
        [uint] $ReportId,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Format')]
        [ValidateSet('csv', 'xlsx', 'pdf')]
        [string] $FileType,

        [Parameter(
            Mandatory = $false)]
        [Alias('Path')]
        [System.IO.FileInfo] $FilePath
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ReportService/ExportReport?id=$ReportId&fileExtension=$FileType"
            'Method'      = 'GET'
            'Description' = "Getting $FileType report with report Id: $ReportId"
        }

        if ($PSCmdlet.ShouldProcess("Getting $([environment]::NewLine) $FileType report with report Id: $ReportId", "$FileType report with report Id: $ReportId", 'Getting:')) {
            [byte[]] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            if ($null -ne $FilePath) {
                Set-Content -Path $FilePath -AsByteStream -Value $result
            } else {
                return $result
            }
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

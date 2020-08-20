function Get-LockpathWebResponseContent {
    [CmdletBinding(SupportsShouldProcess)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]

    param(
        [System.Net.HttpWebResponse] $WebResponse
    )

    Write-LockpathInvocationLog

    $streamReader = $null

    try {
        $content = $null

        if (($null -ne $WebResponse) -and ($WebResponse.ContentLength -gt 0)) {
            $stream = $WebResponse.GetResponseStream()
            $encoding = [System.Text.Encoding]::UTF8
            if (-not [String]::IsNullOrWhiteSpace($WebResponse.ContentEncoding)) {
                $encoding = [System.Text.Encoding]::GetEncoding($WebResponse.ContentEncoding)
            }

            $streamReader = New-Object -TypeName System.IO.StreamReader -ArgumentList ($stream, $encoding)
            $content = $streamReader.ReadToEnd()
        }

        return $content
    } finally {
        if ($null -ne $streamReader) {
            $streamReader.Close()
        }
    }
}

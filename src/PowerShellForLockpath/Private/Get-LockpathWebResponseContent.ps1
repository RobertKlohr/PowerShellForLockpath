function Get-LockpathWebResponseContent {
    <#
    .SYNOPSIS
        Returns the content that may be contained within an HttpWebResponse object.

    .DESCRIPTION
        Returns the content that may be contained within an HttpWebResponse object.

        This would commonly be used when trying to get the potential content returned within a failing WebResponse.
        Normally, when you call Invoke-WebRequest, it returns back a BasicHtmlWebResponseObject which directly
        contains a Content property, however if the web request fails, you get a WebException which contains a simpler WebResponse, which requires a bit more effort in order to access the raw response content.

    .PARAMETER WebResponse
        An HttpWebResponse object, typically the Response property on a WebException.

    .EXAMPLE
        Get-LockpathWebResponseContent

    .INPUTS
        String

    .OUTPUTS
        String

        The raw content that was included in a WebResponse; $null otherwise.

    .NOTES
        The authentication account must have access to the API.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    #FIXME test to see this function is ever called when using Lockpath

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [System.Net.HttpWebResponse] $WebResponse
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

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

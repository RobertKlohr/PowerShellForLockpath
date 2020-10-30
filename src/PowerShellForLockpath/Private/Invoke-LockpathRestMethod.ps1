function Invoke-LockpathRestMethod {
    #FIXME Update to new coding standards
    #FIXME compress error messages to a single line


    #FIXME Clean up help
    <#
    .SYNOPSIS
        A wrapper around Invoke-WebRequest that understands the GitHub API.

    .DESCRIPTION
        A very heavy wrapper around Invoke-WebRequest that understands the GitHub API and
        how to perform its operation with and without console status updates.  It also
        understands how to parse and handle errors from the REST calls.

        The Git repo for this module can be found here: http://aka.ms/PowerShellForGitHub

    .PARAMETER UriFragment
        The unique, tail-end, of the REST URI that indicates what GitHub REST action will
        be performed.  This should not start with a leading "/".

    .PARAMETER Method
        The type of REST method being performed.  This only supports a reduced set of the
        possible REST methods (delete, get, post, put).

    .PARAMETER Description
        A friendly description of the operation being performed for logging and console
        display purposes.

    .PARAMETER Body
        This optional parameter forms the body of a PUT or POST request. It will be automatically
        encoded to UTF8 and sent as Content Type: "application/json; charset=UTF-8"

    .PARAMETER AcceptHeader
        Specify the media type in the Accept header.  Different types of commands may require
        different media types.

    .PARAMETER InFile
        Gets the content of the web request from the specified file.  Only valid for POST requests.

    .PARAMETER ContentType
        Specifies the value for the MIME Content-Type header of the request.  This will usually
        be configured correctly automatically.  You should only specify this under advanced
        situations (like if the extension of InFile is of a type unknown to this module).

    .PARAMETER ExtendedResult
        If specified, the result will be a PSObject that contains the normal result, along with
        the response code and other relevant header detail content.

    .PARAMETER Save
        If specified, this will save the result to a temporary file and return the FileInfo of that
        temporary file.

    .PARAMETER AccessToken
        If provided, this will be used as the AccessToken for authentication with the
        REST Api as opposed to requesting a new one.

    .PARAMETER TelemetryEventName
        If provided, the successful execution of this REST command will be logged to telemetry
        using this event name.

    .PARAMETER TelemetryProperties
        If provided, the successful execution of this REST command will be logged to telemetry
        with these additional properties.  This will be silently ignored if TelemetryEventName
        is not provided as well.

    .PARAMETER TelemetryExceptionBucket
        If provided, any exception that occurs will be logged to telemetry using this bucket.
        It's possible that users will wish to log exceptions but not success (by providing
        TelemetryEventName) if this is being executed as part of a larger scenario.  If this
        isn't provided, but TelemetryEventName *is* provided, then TelemetryEventName will be
        used as the exception bucket value in the event of an exception.  If neither is specified,
        no bucket value will be used.

    .OUTPUTS
        [PSCustomObject] - The result of the REST operation, in whatever form it comes in.
        [FileInfo] - The temporary file created for the downloaded file if -Save was specified.

    .EXAMPLE
        Invoke-GHRestMethod -UriFragment "users/octocat" -Method Get -Description "Get information on the octocat user"

        Gets the user information for Octocat.

    .EXAMPLE
        Invoke-GHRestMethod -UriFragment "user" -Method Get -Description "Get current user"

        Gets information about the current authenticated user.

    .NOTES
        This wraps Invoke-WebRequest as opposed to Invoke-RestMethod because we want access
        to the headers that are returned in the response, and Invoke-RestMethod drops those headers.
#>



    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory)]
        [string] $UriFragment,

        [Parameter(Mandatory)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [string] $Method,

        [string] $AcceptHeader = $(Get-LockpathConfiguration -Name 'acceptHeader'),

        [string] $Body = $null,

        [string] $Description = $null,

        [string] $hostName = $(Get-LockpathConfiguration -Name 'instanceName'),

        [uint]      $portNumber = $(Get-LockpathConfiguration -Name 'instancePort'),

        [string] $protocol = $(Get-LockpathConfiguration -Name 'instanceProtocol'),

        [String[]] $MethodContainsBody = $(Get-LockpathConfiguration -Name 'MethodContainsBody'),

        [string] $UserAgent = $(Get-LockpathConfiguration -Name 'userAgent')
    )

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    # Normalize our Uri fragment to remove leading "/" or trailing '/'
    if ($UriFragment.StartsWith('/')) {
        $UriFragment = $UriFragment.Substring(1)
    }
    if ($UriFragment.EndsWIth('/')) {
        $UriFragment = $UriFragment.Substring(0, $UriFragment.Length - 1)
    }
    if ([String]::IsNullOrEmpty($Description)) {
        $Description = "Executing: $UriFragment"
    }
    $url = "${Protocol}://${HostName}:$PortNumber/$UriFragment"
    $headers = @{
        'Accept'     = $AcceptHeader
        'User-Agent' = $UserAgent
    }

    if ($Method -in $MethodContainsBody) {
        $headers.Add('Content-Type', 'application/json')
    }

    try {
        Write-LockpathLog -Message $Description -Level Verbose
        Write-LockpathLog -Message "Accessing [$Method] $url [Timeout = $(Get-LockpathConfiguration -Name WebRequestTimeoutSec))]" -Level Verbose

        if ($PSCmdlet.ShouldProcess($url, 'Invoke-WebRequest')) {
            $params = @{ }
            $params.Add('Uri', $url)
            $params.Add('Method', $Method)
            $params.Add('Headers', $headers)
            $params.Add('TimeoutSec', (Get-LockpathConfiguration -Name WebRequestTimeoutSec))
            #If the call is a login then capture the WebRequestSession object else send the WebRequestSession object.
            if ($UriFragment -eq 'SecurityService/Login') {
                $params.Add('Body', $Body)
                $params.Add('SessionVariable', 'webSession')
            } else {
                $params.Add('WebSession', $script:configuration.webSession)
            }
            if ($Method -in $methodContainsBody -and $UriFragment -ne 'SecurityService/Login' -and (-not [String]::IsNullOrEmpty($Body))) {
                #FIXME why encode as bytes, works with login but not get detail records
                $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                $params.Add('Body', $bodyAsBytes)
                #$params.Add('Body', $Body)
                Write-LockpathLog -Message 'Request includes a body.' -Level Verbose
                if (Get-LockpathConfiguration -Name LogRequestBody) {
                    Write-LockpathLog -Message $Body -Level Verbose
                }
            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $ProgressPreference = 'SilentlyContinue'
            $result = Invoke-WebRequest @params
            $ProgressPreference = 'Continue'
            if ($UriFragment -eq 'SecurityService/Login') {
                $script:configuration.webSession = $webSession
            }
            if ($Method -eq 'Delete') {
                Write-LockpathLog -Message 'Successfully removed.' -Level Verbose
            }
        }

        $finalResult = $result.Content
        try {
            $finalResult = $finalResult | ConvertFrom-Json -AsHashtable -NoEnumerate
        } catch [System.ArgumentException] {
            # The content must not be JSON (which is a legitimate situation).  We'll return the raw content result instead.
            # We do this unnecessary assignment to avoid PSScriptAnalyzer's PSAvoidUsingEmptyCatchBlock.
            $finalResult = $finalResult
        }

        $resultNotReadyStatusCode = 202
        if ($result.StatusCode -eq $resultNotReadyStatusCode) {
            $retryDelaySeconds = Get-LockpathConfiguration -Name RetryDelaySeconds

            if ($Method -ne 'Get') {
                # We only want to do our retry logic for GET requests...
                # We don't want to repeat PUT/PATCH/POST/DELETE.
                Write-LockpathLog -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)])." -Level Warning
            } elseif ($retryDelaySeconds -le 0) {
                Write-LockpathLog -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]), however the module is currently configured to not retry in this scenario (RetryDelaySeconds is set to 0).  Please try this command again later." -Level Warning
            } else {
                Write-LockpathLog -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]).  Will retry in [$retryDelaySeconds] seconds." -Level Warning
                Start-Sleep -Seconds ($retryDelaySeconds)
                return (Invoke-LockpathRestMethod @PSBoundParameters)
            }
        }
        return $result.Content
        # return $finalResult
    } catch {
        $ex = $null
        $message = $null
        $statusCode = $null
        $statusDescription = $null
        $innerMessage = $null
        $rawContent = $null

        if ($_.Exception -is [System.Net.WebException]) {
            $ex = $_.Exception
            $message = $_.Exception.Message
            $statusCode = $ex.Response.StatusCode.value__ # Note that value__ is not a typo.
            $statusDescription = $ex.Response.StatusDescription
            $innerMessage = $_.ErrorDetails.Message
            try {
                $rawContent = Get-LockpathWebResponseContent -WebResponse $ex.Response
            } catch {
                Write-LockpathLog -Message 'Unable to retrieve the raw HTTP Web Response:' -Exception $_ -Level Warning
            }

        } else {
            Write-LockpathLog -Exception $_ -Level Error
            throw
        }

        $output = @()
        $output += $message

        if (-not [string]::IsNullOrEmpty($statusCode)) {
            $output += "$statusCode | $($statusDescription.Trim())"
        }

        if (-not [string]::IsNullOrEmpty($innerMessage)) {
            try {
                $innerMessageJson = ($innerMessage | ConvertFrom-Json)
                if ($innerMessageJson -is [String]) {
                    $output += $innerMessageJson.Trim()
                } elseif (-not [String]::IsNullOrWhiteSpace($innerMessageJson.message)) {
                    $output += "$($innerMessageJson.message.Trim())"
                    if ($innerMessageJson.details) {
                        $output += "$($innerMessageJson.details | Format-Table | Out-String)"
                    }
                } else {
                    # In this case, it's probably not a normal message from the API
                    $output += ($innerMessageJson | Out-String)
                }
            } catch [System.ArgumentException] {
                # Will be thrown if $innerMessage isn't JSON content
                $output += $innerMessage.Trim()
            }
        }

        # It's possible that the API returned JSON content in its error response.
        if (-not [String]::IsNullOrWhiteSpace($rawContent)) {
            $output += $rawContent
        }

        #TODO Add some logic here for capturing details from all the generic 400 errors that should be 401 or 403 errors

        if ($statusCode -eq 404) {
            $output += 'This typically happens when the API call has an error in the URL.'
        }

        if ($statusCode -eq 405) {
            $output += 'This typically happens when the API call is using the wrong method.'
        }

        $newLineOutput = ($output -join [Environment]::NewLine)
        Write-LockpathLog -Message $newLineOutput -Level Error
        throw $newLineOutput
        Write-Error $newLineOutput
    }
}

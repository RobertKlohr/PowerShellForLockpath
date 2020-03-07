# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

@{
    DefaultAcceptHeader               = 'application/json'
    ValidBodyContainingRequestMethods = ("Delete", "Post")

}.GetEnumerator() | ForEach-Object {
    Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
}

function Invoke-LockpathRestMethod {
    <#
        .SYNOPSIS
            A wrapper around Invoke-RestMethod that understands the Lockpath API.

        .DESCRIPTION
            A wrapper around Invoke-RestMethod that understands the Lockpath API.response from the server.

        .PARAMETER UriFragment
            The unique, tail-end, of the REST URI that indicates what Store REST action will be performed.  This should not start with a leading "/".

        .PARAMETER Method
            The type of REST method being performed.  This only supports a reduced set of the possible REST methods (delete, get, post, put).

        .PARAMETER Description
            A friendly description of the operation being performed for logging and console display purposes.

        .PARAMETER Body
            This optional parameter forms the body of a PUT or POST request. It will be automatically         encoded to UTF8 and sent as Content Type: "application/json; charset=UTF-8"

        .PARAMETER AcceptHeader
        Specify the media type in the Accept header.  Different types of commands may require different media types.

        .PARAMETER ExtendedResult
            If specified, the result will be a PSObject that contains the normal result, along with the response code and other relevant header detail content.

        .PARAMETER AuthenticationCookie
            If provided, this will be used as the cookie for authentication with the REST Api as opposed to requesting a new one.

        .OUTPUTS
            [PSCustomObject] - The result of the REST operation, in whatever form it comes in.

        .EXAMPLE
            Invoke-LockpathRestMethod

        .NOTES
            This uses Invoke-RestMethod instead of Invoke-WebRequest because the Lockpath API is very limited and does not provide detailed request status messages or any other information that would require the use of Invoke-WebRequest to capture for status updates or logging.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $UriFragment,

        [Parameter(Mandatory)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [string] $Method,

        [string] $Description,

        [string] $Body = $null,

        [string] $AcceptHeader = $script:DefaultAcceptHeader,

        [switch] $ExtendedResult,

        [Microsoft.PowerShell.Commands.WebRequestSession] $WebSession,

        [switch] $NoStatus
    )

    # Normalize our Uri fragment.  It might be coming from a method implemented here, or it might
    # be coming from the Location header in a previous response.  Either way, we don't want there
    # to be a leading "/" or trailing '/'
    if ($UriFragment.StartsWith('/')) {
        $UriFragment = $UriFragment.Substring(1)
    }
    if ($UriFragment.EndsWIth('/')) {
        $UriFragment = $UriFragment.Substring(0, $UriFragment.Length - 1)
    }

    if ([String]::IsNullOrEmpty($Description)) {
        $Description = "Executing: $UriFragment"
    }

    $hostName = $(Get-LockpathConfiguration -Name "ApiHostName")
    $portNumber = $(Get-LockpathConfiguration -Name "ApiHostPort")

    $url = "https://${hostName}:$portNumber/$UriFragment"

    # It's possible that we are directly calling the "nextLink" from a previous command which
    # provides the full URI.  If that's the case, we'll just use exactly what was provided to us.
    if ($UriFragment.StartsWith('http')) {
        $url = $UriFragment
    }

    $headers = @{
        'Accept'     = $AcceptHeader
        #TODO: move this to the configuration object and file
        'User-Agent' = "PowerShell/$($PSVersionTable.PSVersion.ToString(2)) PowerShellForLockpath"
    }

    if ($Method -in $ValidBodyContainingRequestMethods) {
        $headers.Add("Content-Type", "application/json")
    }

    try {
        Write-Log -Message $Description -Level Verbose
        Write-Log -Message "Accessing [$Method] $url [Timeout = $(Get-LockpathConfiguration -Name WebRequestTimeoutSec))]" -Level Verbose

        if ($PSCmdlet.ShouldProcess($url, "Invoke-RestMethod")) {
            $params = @{ }
            $params.Add("Uri", $url)
            $params.Add("Method", $Method)
            $params.Add("Headers", $headers)

            if ($Method -in $ValidBodyContainingRequestMethods -and (-not [String]::IsNullOrEmpty($Body))) {
                # $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                $params.Add("Body", $Body)
                Write-Log -Message "Request includes a body." -Level Verbose
                if (Get-LockpathConfiguration -Name LogRequestBody) {
                    #TODO: Need to filter out logging the password
                    Write-Log -Message $Body -Level Verbose
                }
            }

            # If the call if login capture the web session else use the existing web session
            if ($UriFragment = 'SecurityService/Login') {
                $params.Add('SessionVariable', 'RestSession')
            } else {
                $params.Add('WebSession', $WebSession)
            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $response = Invoke-RestMethod @params #-ErrorAction Stop
            if ($Method -eq 'Delete') {
                Write-Log -Message "Successfully removed." -Level Verbose
            }
        }

        if (-not (Get-LockpathConfiguration -Name DisableSmarterObjects)) {
            $response = ConvertTo-SmarterObject -InputObject $response
        }

        $links = $response.Headers['Link'] -split ','
        $nextLink = $null
        foreach ($link in $links) {
            if ($link -match '<(.*)>; rel="next"') {
                $nextLink = $matches[1]
            }
        }

        if ($ExtendedResult) {
            $responseEx = @{
                'result'             = $response
                'statusCode'         = $response.StatusCode
                'requestId'          = $response.Headers['X-GitHub-Request-Id']
                'nextLink'           = $nextLink
                'link'               = $response.Headers['Link']
                'lastModified'       = $response.Headers['Last-Modified']
                'ifNoneMatch'        = $response.Headers['If-None-Match']
                'ifModifiedSince'    = $response.Headers['If-Modified-Since']
                'eTag'               = $response.Headers['ETag']
                'rateLimit'          = $response.Headers['X-RateLimit-Limit']
                'rateLimitRemaining' = $response.Headers['X-RateLimit-Remaining']
                'rateLimitReset'     = $response.Headers['X-RateLimit-Reset']
            }

            return ([PSCustomObject] $responseEx)
        } else {
            return $response
        }
    } catch {
        #TODO: look to see if there are some status codes we can capture and log
        #TODO: REGEX to parse response:
        # ^.*(\w\r\n\s*)\K.*[^\s]
        # Get the message returned from the server which will be in JSON format
        #TODO: Get Lockpath to return error messages in JSON or XML and not HTML with CSS
        #TODO: grab errordetails.message, Exception.Message, ScriptStackTrace and Exception.Response.StatusCode.value__,
        $ErrorMessage = $_.ErrorDetails.Message | ConvertFrom-Json | Select-Object -ExpandProperty Message
        $ErrorRecord = New-Object System.Management.Automation.ErrorRecord(
            (New-Object Exception("Exception executing the Invoke-RestMethod cmdlet. $($ErrorMessage)")),
            'Invoke-RestMethod',
            [System.Management.Automation.ErrorCategory]$_.CategoryInfo.Category,
            $parameters
        )
        $ErrorRecord.CategoryInfo.Reason = $_.CategoryInfo.Reason;
        $ErrorRecord.CategoryInfo.Activity = $_.InvocationInfo.InvocationName;
        $PSCmdlet.ThrowTerminatingError($ErrorRecord);
        Write-Log -Exception $_ -Level Error
        throw
    }
}
function Invoke-LockpathRestMethod1 {
    <#
    .SYNOPSIS
        A wrapper around Invoke-WebRequest that understands the Lockpath API.

    .DESCRIPTION
        A very heavy wrapper around Invoke-WebRequest that understands the Lockpath API and how to perform its operation
        with and without console status updates.  It also understands how to parse and handle errors from the REST
        calls.

        The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath

    .PARAMETER UriFragment
        The unique, tail-end, of the REST URI that indicates what Lockpath REST action will be performed.  This should not start with a leading "/".

    .PARAMETER Method
        The type of REST method being performed.  This only supports a reduced set of the possible REST methods (delete, get, post).

    .PARAMETER Description
        A friendly description of the operation being performed for logging and console display purposes.

    .PARAMETER Body
        This optional parameter forms the body of a Delete or POST request.

    .PARAMETER AcceptHeader
        Specify the media type in the Accept header.  Different types of commands may require different media types.

    .PARAMETER ExtendedResult
        If specified, the result will be a PSObject that contains the normal result, along with the response code and other relevant header detail content.

    .PARAMETER AccessToken
        If provided, this will be used as the AccessToken for authentication with the REST Api as opposed to requesting a new one.

    .PARAMETER NoStatus
        If this switch is specified, long-running commands will run on the main thread
        with no commandline status update.  When not specified, those commands run in
        the background, enabling the command prompt to provide status information.

    .OUTPUTS
        [PSCustomObject] - The result of the REST operation, in whatever form it comes in.

    .EXAMPLE
        Invoke-LockpathRestMethod -UriFragment "applications/" -Method Get -Description "Get first 10 applications"

        Gets the first 10 applications for the connected dev account.

    .EXAMPLE
        Invoke-GHRestMethod -UriFragment "applications/0ABCDEF12345/submissions/1234567890123456789/" -Method Delete -Description "Delete Submission" -NoStatus

        Deletes the specified submission, but the request happens in the foreground and there is
        no additional status shown to the user until a response is returned from the REST request.

    .NOTES
        This wraps Invoke-WebRequest as opposed to Invoke-RestMethod because we want access to the headers
        that are returned in the response (specifically 'MS-ClientRequestId') for logging purposes, and
        Invoke-RestMethod drops those headers.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $UriFragment,

        [Parameter(Mandatory)]
        [ValidateSet('Delete', 'Get', 'Post', 'Patch', 'Put')]
        [string] $Method,

        [string] $Description,

        [string] $Body = $null,

        [string] $AcceptHeader = $script:defaultAcceptHeader,

        [switch] $ExtendedResult,

        [string] $AccessToken,

        [string] $TelemetryEventName = $null,

        [hashtable] $TelemetryProperties = @{ },

        [string] $TelemetryExceptionBucket = $null,

        [switch] $NoStatus
    )

    # Normalize our Uri fragment.  It might be coming from a method implemented here, or it might
    # be coming from the Location header in a previous response.  Either way, we don't want there
    # to be a leading "/" or trailing '/'
    if ($UriFragment.StartsWith('/')) {
        $UriFragment = $UriFragment.Substring(1)
    }
    if ($UriFragment.EndsWIth('/')) {
        $UriFragment = $UriFragment.Substring(0, $UriFragment.Length - 1)
    }

    if ([String]::IsNullOrEmpty($Description)) {
        $Description = "Executing: $UriFragment"
    }

    # Telemetry-related
    $stopwatch = New-Object -TypeName System.Diagnostics.Stopwatch
    $localTelemetryProperties = @{
        'UriFragment'       = $UriFragment
        'WaitForCompletion' = ($WaitForCompletion -eq $true)
    }
    $TelemetryProperties.Keys | ForEach-Object { $localTelemetryProperties[$_] = $TelemetryProperties[$_] }
    $errorBucket = $TelemetryExceptionBucket
    if ([String]::IsNullOrEmpty($errorBucket)) {
        $errorBucket = $TelemetryEventName
    }

    # Since we have retry logic, we won't create a new stopwatch every time,
    # we'll just always continue the existing one...
    $stopwatch.Start()

    $hostName = $(Get-GitHubConfiguration -Name "ApiHostName")

    if ($hostName -eq 'github.com') {
        $url = "https://api.$hostName/$UriFragment"
    } else {
        $url = "https://$hostName/api/v3/$UriFragment"
    }

    # It's possible that we are directly calling the "nextLink" from a previous command which
    # provides the full URI.  If that's the case, we'll just use exactly what was provided to us.
    if ($UriFragment.StartsWith('http')) {
        $url = $UriFragment
    }

    $headers = @{
        'Accept'     = $AcceptHeader
        'User-Agent' = 'PowerShellForGitHub'
    }

    $AccessToken = Get-AccessToken -AccessToken $AccessToken
    if (-not [String]::IsNullOrEmpty($AccessToken)) {
        $headers['Authorization'] = "token $AccessToken"
    }

    if ($Method -in $ValidBodyContainingRequestMethods) {
        $headers.Add("Content-Type", "application/json; charset=UTF-8")
    }

    try {
        Write-Log -Message $Description -Level Verbose
        Write-Log -Message "Accessing [$Method] $url [Timeout = $(Get-GitHubConfiguration -Name WebRequestTimeoutSec))]" -Level Verbose

        $NoStatus = Resolve-ParameterWithDefaultConfigurationValue -Name NoStatus -ConfigValueName DefaultNoStatus
        if ($NoStatus) {
            if ($PSCmdlet.ShouldProcess($url, "Invoke-WebRequest")) {
                $params = @{ }
                $params.Add("Uri", $url)
                $params.Add("Method", $Method)
                $params.Add("Headers", $headers)
                $params.Add("UseDefaultCredentials", $true)
                $params.Add("UseBasicParsing", $true)
                $params.Add("TimeoutSec", (Get-GitHubConfiguration -Name WebRequestTimeoutSec))

                if ($Method -in $ValidBodyContainingRequestMethods -and (-not [String]::IsNullOrEmpty($Body))) {
                    $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                    $params.Add("Body", $bodyAsBytes)
                    Write-Log -Message "Request includes a body." -Level Verbose
                    if (Get-GitHubConfiguration -Name LogRequestBody) {
                        Write-Log -Message $Body -Level Verbose
                    }
                }

                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $result = Invoke-WebRequest @params
                if ($Method -eq 'Delete') {
                    Write-Log -Message "Successfully removed." -Level Verbose
                }
            }
        } else {
            $jobName = "Invoke-GHRestMethod-" + (Get-Date).ToFileTime().ToString()

            if ($PSCmdlet.ShouldProcess($jobName, "Start-Job")) {
                [scriptblock]$scriptBlock = {
                    param($Url, $Method, $Headers, $Body, $ValidBodyContainingRequestMethods, $TimeoutSec, $LogRequestBody, $ScriptRootPath)

                    # We need to "dot invoke" Helpers.ps1 and GitHubConfiguration.ps1 within
                    # the context of this script block since we're running in a different
                    # PowerShell process and need access to Get-HttpWebResponseContent and
                    # config values referenced within Write-Log.
                    . (Join-Path -Path $ScriptRootPath -ChildPath 'Helpers.ps1')
                    . (Join-Path -Path $ScriptRootPath -ChildPath 'GitHubConfiguration.ps1')

                    $params = @{ }
                    $params.Add("Uri", $Url)
                    $params.Add("Method", $Method)
                    $params.Add("Headers", $Headers)
                    $params.Add("UseDefaultCredentials", $true)
                    $params.Add("UseBasicParsing", $true)
                    $params.Add("TimeoutSec", $TimeoutSec)

                    if ($Method -in $ValidBodyContainingRequestMethods -and (-not [String]::IsNullOrEmpty($Body))) {
                        $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                        $params.Add("Body", $bodyAsBytes)
                        Write-Log -Message "Request includes a body." -Level Verbose
                        if ($LogRequestBody) {
                            Write-Log -Message $Body -Level Verbose
                        }
                    }

                    try {
                        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                        Invoke-WebRequest @params
                    } catch [System.Net.WebException] {
                        # We need to access certain headers in the exception handling,
                        # but the actual *values* of the headers of a WebException don't get serialized
                        # when the RemoteException wraps it.  To work around that, we'll extract the
                        # information that we actually care about *now*, and then we'll throw our own exception
                        # that is just a JSON object with the data that we'll later extract for processing in
                        # the main catch.
                        $ex = @{ }
                        $ex.Message = $_.Exception.Message
                        $ex.StatusCode = $_.Exception.Response.StatusCode
                        $ex.StatusDescription = $_.Exception.Response.StatusDescription
                        $ex.InnerMessage = $_.ErrorDetails.Message
                        try {
                            $ex.RawContent = Get-HttpWebResponseContent -WebResponse $_.Exception.Response
                        } catch {
                            Write-Log -Message "Unable to retrieve the raw HTTP Web Response:" -Exception $_ -Level Warning
                        }

                        throw (ConvertTo-Json -InputObject $ex -Depth 20)
                    }
                }

                $null = Start-Job -Name $jobName -ScriptBlock $scriptBlock -Arg @(
                    $url,
                    $Method,
                    $headers,
                    $Body,
                    $ValidBodyContainingRequestMethods,
                    (Get-GitHubConfiguration -Name WebRequestTimeoutSec),
                    (Get-GitHubConfiguration -Name LogRequestBody),
                    $PSScriptRoot)

                if ($PSCmdlet.ShouldProcess($jobName, "Wait-JobWithAnimation")) {
                    Wait-JobWithAnimation -Name $jobName -Description $Description
                }

                if ($PSCmdlet.ShouldProcess($jobName, "Receive-Job")) {
                    $result = Receive-Job $jobName -AutoRemoveJob -Wait -ErrorAction SilentlyContinue -ErrorVariable remoteErrors
                }
            }

            if ($remoteErrors.Count -gt 0) {
                throw $remoteErrors[0].Exception
            }

            if ($Method -eq 'Delete') {
                Write-Log -Message "Successfully removed." -Level Verbose
            }
        }

        # Record the telemetry for this event.
        $stopwatch.Stop()
        if (-not [String]::IsNullOrEmpty($TelemetryEventName)) {
            $telemetryMetrics = @{ 'Duration' = $stopwatch.Elapsed.TotalSeconds }
            Set-TelemetryEvent -EventName $TelemetryEventName -Properties $localTelemetryProperties -Metrics $telemetryMetrics
        }

        $finalResult = $result.Content
        try {
            $finalResult = $finalResult | ConvertFrom-Json
        } catch [ArgumentException] {
            # The content must not be JSON (which is a legitimate situation).  We'll return the raw content result instead.
            # We do this unnecessary assignment to avoid PSScriptAnalyzer's PSAvoidUsingEmptyCatchBlock.
            $finalResult = $finalResult
        }

        if (-not (Get-GitHubConfiguration -Name DisableSmarterObjects)) {
            $finalResult = ConvertTo-SmarterObject -InputObject $finalResult
        }

        $links = $result.Headers['Link'] -split ','
        $nextLink = $null
        foreach ($link in $links) {
            if ($link -match '<(.*)>; rel="next"') {
                $nextLink = $matches[1]
            }
        }

        $resultNotReadyStatusCode = 202
        if ($result.StatusCode -eq $resultNotReadyStatusCode) {
            $retryDelaySeconds = Get-GitHubConfiguration -Name RetryDelaySeconds

            if ($Method -ne 'Get') {
                # We only want to do our retry logic for GET requests...
                # We don't want to repeat PUT/PATCH/POST/DELETE.
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)])." -Level Warning
            } elseif ($retryDelaySeconds -le 0) {
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]), however the module is currently configured to not retry in this scenario (RetryDelaySeconds is set to 0).  Please try this command again later." -Level Warning
            } else {
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]).  Will retry in [$retryDelaySeconds] seconds." -Level Warning
                Start-Sleep -Seconds ($retryDelaySeconds)
                return (Invoke-GHRestMethod @PSBoundParameters)
            }
        }

        if ($ExtendedResult) {
            $finalResultEx = @{
                'result'             = $finalResult
                'statusCode'         = $result.StatusCode
                'requestId'          = $result.Headers['X-GitHub-Request-Id']
                'nextLink'           = $nextLink
                'link'               = $result.Headers['Link']
                'lastModified'       = $result.Headers['Last-Modified']
                'ifNoneMatch'        = $result.Headers['If-None-Match']
                'ifModifiedSince'    = $result.Headers['If-Modified-Since']
                'eTag'               = $result.Headers['ETag']
                'rateLimit'          = $result.Headers['X-RateLimit-Limit']
                'rateLimitRemaining' = $result.Headers['X-RateLimit-Remaining']
                'rateLimitReset'     = $result.Headers['X-RateLimit-Reset']
            }

            return ([PSCustomObject] $finalResultEx)
        } else {
            return $finalResult
        }
    } catch {
        # We only know how to handle WebExceptions, which will either come in "pure" when running with -NoStatus,
        # or will come in as a RemoteException when running normally (since it's coming from the asynchronous Job).
        $ex = $null
        $message = $null
        $statusCode = $null
        $statusDescription = $null
        $requestId = $null
        $innerMessage = $null
        $rawContent = $null

        if ($_.Exception -is [System.Net.WebException]) {
            $ex = $_.Exception
            $message = $_.Exception.Message
            $statusCode = $ex.Response.StatusCode.value__ # Note that value__ is not a typo.
            $statusDescription = $ex.Response.StatusDescription
            $innerMessage = $_.ErrorDetails.Message
            try {
                $rawContent = Get-HttpWebResponseContent -WebResponse $ex.Response
            } catch {
                Write-Log -Message "Unable to retrieve the raw HTTP Web Response:" -Exception $_ -Level Warning
            }

            if ($ex.Response.Headers.Count -gt 0) {
                $requestId = $ex.Response.Headers['X-GitHub-Request-Id']
            }
        } elseif (($_.Exception -is [System.Management.Automation.RemoteException]) -and
            ($_.Exception.SerializedRemoteException.PSObject.TypeNames[0] -eq 'Deserialized.System.Management.Automation.RuntimeException')) {
            $ex = $_.Exception
            try {
                $deserialized = $ex.Message | ConvertFrom-Json
                $message = $deserialized.Message
                $statusCode = $deserialized.StatusCode
                $statusDescription = $deserialized.StatusDescription
                $innerMessage = $deserialized.InnerMessage
                $requestId = $deserialized['X-GitHub-Request-Id']
                $rawContent = $deserialized.RawContent
            } catch [System.ArgumentException] {
                # Will be thrown if $ex.Message isn't JSON content
                Write-Log -Exception $_ -Level Error
                Set-TelemetryException -Exception $ex -ErrorBucket $errorBucket -Properties $localTelemetryProperties
                throw
            }
        } else {
            Write-Log -Exception $_ -Level Error
            Set-TelemetryException -Exception $_.Exception -ErrorBucket $errorBucket -Properties $localTelemetryProperties
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
                    $output += "$($innerMessageJson.message.Trim()) | $($innerMessageJson.documentation_url.Trim())"
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

        if ($statusCode -eq 404) {
            $output += "This typically happens when the current user isn't properly authenticated.  You may need an Access Token with additional scopes checked."
        }

        if (-not [String]::IsNullOrEmpty($requestId)) {
            $localTelemetryProperties['RequestId'] = $requestId
            $message = 'RequestId: ' + $requestId
            $output += $message
            Write-Log -Message $message -Level Verbose
        }

        $newLineOutput = ($output -join [Environment]::NewLine)
        Write-Log -Message $newLineOutput -Level Error
        Set-TelemetryException -Exception $ex -ErrorBucket $errorBucket -Properties $localTelemetryProperties
        throw $newLineOutput
    }
}

function Send-LockpathLogin {
    <#
    .SYNOPSIS
        Authenticates to the Lockpath API Host.

    .DESCRIPTION
        Authenticates to the Lockpath API Host.

        The Git repo for this module can be found here: https://github.com/RjKGitHub/PowerShellForLockpath

    .NOTES
        The credentials used to login are configured with 'Set-LockpathAuthentication'.

    .EXAMPLE
        Send-LockpathLogin

        Authenticates to the Lockpath API host in the session configuration using the credentials configured by using 'Set-LockpathAuthentication'.
#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.")]
    param()

    Write-InvocationLog

    $credential = Get-LockpathAuthentication
    $hashBody = @{ }
    $hashBody = [ordered]@{
        'username' = $credential.username
        'password' = $credential.GetNetworkCredential().Password
    }

    $params = @{ }

    $params = @{
        'UriFragment' = '/SecurityService/Login'
        'Method'      = 'Get'
        'Body'        = (ConvertTo-Json -InputObject $hashBody)
        'Description' = "Login to $($script:configuration.apiHostName) with $($credential.username)"
    }
    Invoke-LockpathRestMethod @params
}

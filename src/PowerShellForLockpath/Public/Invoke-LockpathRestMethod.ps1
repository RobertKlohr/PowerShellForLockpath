function Invoke-LockpathRestMethod {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $UriFragment,

        [Parameter(Mandatory)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [string] $Method,

        [string] $AcceptHeader = $script:defaultAcceptHeader,

        [string] $AuthenticationCookie = $script:AuthenticationCookie,

        [string] $Body = $null,

        [string] $Description,

        [switch] $NoStatus
    )

    Write-InvocationLog

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

    $hostName = $(Get-Configuration -Name "InstanceName")
    $portNumber = $(Get-Configuration -Name "instancePort")
    $protocol = $(Get-Configuration -Name "instanceProtocol")

    $url = "${protocol}://${hostName}:$portNumber/$UriFragment"

    # It's possible that we are directly calling the "nextLink" from a previous command which
    # provides the full URI.  If that's the case, we'll just use exactly what was provided to us.
    if ($UriFragment.StartsWith('http')) {
        $url = $UriFragment
    }

    $headers = @{
        'Accept'     = $AcceptHeader
        'User-Agent' = $UserAgent
    }

    # $AccessToken = Get-AccessToken -AccessToken $AccessToken
    # if (-not [String]::IsNullOrEmpty($AccessToken)) {
    #     $headers['Authorization'] = "token $AccessToken"
    # }

    if ($Method -in $ValidBodyContainingRequestMethods) {
        $headers.Add("Content-Type", "application/json")
    }

    try {
        Write-Log -Message $Description -Level Verbose
        Write-Log -Message "Accessing [$Method] $url [Timeout = $(Get-Configuration -Name WebRequestTimeoutSec))]" -Level Verbose

        if ($PSCmdlet.ShouldProcess($url, "Invoke-WebRequest")) {
            $params = @{ }
            $params.Add("Uri", $url)
            $params.Add("Method", $Method)
            $params.Add("Headers", $headers)
            $params.Add("TimeoutSec", (Get-Configuration -Name WebRequestTimeoutSec))
            #If the call is a login then capture the WebRequestSession object else send the WebRequestSession object.
            if ($UriFragment -eq "SecurityService/Login") {
                $params.Add("SessionVariable", "Session")
            } else {
                $params.Add("WebSession", $script:Session)
            }
            if ($Method -in $ValidBodyContainingRequestMethods -and (-not [String]::IsNullOrEmpty($Body))) {
                $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                $params.Add("Body", $bodyAsBytes)
                Write-Log -Message "Request includes a body." -Level Verbose
                if (Get-Configuration -Name LogRequestBody) {
                    Write-Log -Message $Body -Level Verbose
                }
            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $result = Invoke-WebRequest @params
            if ($UriFragment -eq "SecurityService/Login") {
                Set-Variable -Scope Script -Name "Session"
            }
            if ($Method -eq 'Delete') {
                Write-Log -Message "Successfully removed." -Level Verbose
            }
        }

        $finalResult = $result.Content
        try {
            $finalResult = $finalResult | ConvertFrom-Json
        } catch [ArgumentException] {
            # The content must not be JSON (which is a legitimate situation).  We'll return the raw content result instead.
            # We do this unnecessary assignment to avoid PSScriptAnalyzer's PSAvoidUsingEmptyCatchBlock.
            $finalResult = $finalResult
        }

        if (-not (Get-Configuration -Name DisableSmarterObjects)) {
            $finalResult = ConvertTo-SmarterObject -InputObject $finalResult
        }

        #TODO check to see if Lockpath API hands back links on any call
        # $links = $result.Headers['Link'] -split ','
        # $nextLink = $null
        # foreach ($link in $links) {
        #     if ($link -match '<(.*)>; rel="next"') {
        #         $nextLink = $matches[1]
        #     }
        # }

        $resultNotReadyStatusCode = 202
        if ($result.StatusCode -eq $resultNotReadyStatusCode) {
            $retryDelaySeconds = Get-Configuration -Name RetryDelaySeconds

            if ($Method -ne 'Get') {
                # We only want to do our retry logic for GET requests...
                # We don't want to repeat PUT/PATCH/POST/DELETE.
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)])." -Level Warning
            } elseif ($retryDelaySeconds -le 0) {
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]), however the module is currently configured to not retry in this scenario (RetryDelaySeconds is set to 0).  Please try this command again later." -Level Warning
            } else {
                Write-Log -Message "The server has indicated that the result is not yet ready (received status code of [$($result.StatusCode)]).  Will retry in [$retryDelaySeconds] seconds." -Level Warning
                Start-Sleep -Seconds ($retryDelaySeconds)
                return (Invoke-LockpathRestMethod @PSBoundParameters)
            }
        }
        return $finalResult
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
                $rawContent = Get-HttpWebResponseContent -WebResponse $ex.Response
            } catch {
                Write-Log -Message "Unable to retrieve the raw HTTP Web Response:" -Exception $_ -Level Warning
            }

        } else {
            Write-Log -Exception $_ -Level Error
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

        if ($statusCode -eq 404) {
            $output += "This typically happens when the current user isn't properly authenticated.  You may need an Access Token with additional scopes checked."
        }

        $newLineOutput = ($output -join [Environment]::NewLine)
        Write-Log -Message $newLineOutput -Level Error
        throw $newLineOutput
    }
}

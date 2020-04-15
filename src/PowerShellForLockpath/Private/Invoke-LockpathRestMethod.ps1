function Invoke-LockpathRestMethod {
    [CmdletBinding(SupportsShouldProcess)]
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

        [int] $portNumber = $(Get-LockpathConfiguration -Name 'instancePort'),

        [string] $protocol = $(Get-LockpathConfiguration -Name 'instanceProtocol'),

        [String[]] $MethodContainsBody = $(Get-LockpathConfiguration -Name 'MethodContainsBody'),

        [string] $UserAgent = $(Get-LockpathConfiguration -Name 'userAgent')
    )

    Write-LockpathInvocationLog

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
                $params.Add('SessionVariable', 'webSession')
            } else {
                $params.Add('WebSession', $script:configuration.webSession)
            }
            if ($Method -in $methodContainsBody -and (-not [String]::IsNullOrEmpty($Body))) {
                #FIXME why encode as bytes, works with login but not get detail records
                # $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                # $params.Add('Body', $bodyAsBytes)
                $params.Add('Body', $Body)
                Write-LockpathLog -Message 'Request includes a body.' -Level Verbose
                if (Get-LockpathConfiguration -Name LogRequestBody) {
                    Write-LockpathLog -Message $Body -Level Verbose
                }
            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $result = Invoke-WebRequest @params
            if ($UriFragment -eq 'SecurityService/Login') {
                $script:configuration.webSession = $webSession
            }
            if ($Method -eq 'Delete') {
                Write-LockpathLog -Message 'Successfully removed.' -Level Verbose
            }
        }

        $finalResult = $result.Content
        try {
            $finalResult = $finalResult | ConvertFrom-Json
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

        if ($statusCode -eq 404) {
            $output += 'This typically happens when the current user is not properly authenticated.'
        }

        $newLineOutput = ($output -join [Environment]::NewLine)
        Write-LockpathLog -Message $newLineOutput -Level Error
        throw $newLineOutput
    }
}

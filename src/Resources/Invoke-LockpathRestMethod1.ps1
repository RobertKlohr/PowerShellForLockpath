function Invoke-LockpathRestMethod1 {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $UriFragment,

        [Parameter(Mandatory)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [string] $Method,

        [string] $Description,

        [string] $AuthenticationCookie = $script:AuthenticationCookie,

        [string] $Body = $null,

        [string] $AcceptHeader = $script:DefaultAcceptHeader,

        [switch] $ExtendedResult,

        [switch] $NoStatus
    )

    #TODO Check about removing the next line.

    # @{
    #     DefaultAcceptHeader               = 'application/json'
    #     ValidBodyContainingRequestMethods = ("Delete", "Post")

    # }.GetEnumerator() | ForEach-Object {
    #     Set-Variable -Scope Script -Option ReadOnly -Name $_.Key -Value $_.Value
    # }

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
        #TODO: move this to the configuration object and file
        'User-Agent' = "PowerShell/$($PSVersionTable.PSVersion.ToString(2)) PowerShellForLockpath"
    }

    if ($Method -in $ValidBodyContainingRequestMethods) {
        $headers.Add("Content-Type", "application/json")
    }

    try {
        Write-Log -Message $Description -Level Verbose
        Write-Log -Message "Accessing [$Method] $url [Timeout = $(Get-Configuration -Name WebRequestTimeoutSec))]" -Level Verbose

        if ($PSCmdlet.ShouldProcess($url, "Invoke-RestMethod")) {
            $params = @{ }
            $params.Add("Uri", $url)
            $params.Add("Method", $Method)
            $params.Add("Headers", $headers)

            if ($Method -in $ValidBodyContainingRequestMethods -and (-not [String]::IsNullOrEmpty($Body))) {
                # $bodyAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
                $params.Add("Body", $Body)
                Write-Log -Message "Request includes a body." -Level Verbose
                if (Get-Configuration -Name LogRequestBody) {
                    #TODO: Need to filter out logging the password
                    Write-Log -Message $Body -Level Verbose
                }
            }

            # If the call is a login capture the cookie else use the build a web session using the passed cookie
            if ($UriFragment -eq 'SecurityService/Login') {
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

        if (-not (Get-Configuration -Name DisableSmarterObjects)) {
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
        # TODO: grab errordetails.message, Exception.Message, ScriptStackTrace and
        # Exception.Response.StatusCode.value__,
        $ErrorMessageRaw = $_.ErrorDetails.Message
        try {
            $ErrorMessage = $ErrorMessageRaw | ConvertFrom-Json | Select-Object -ExpandProperty Message
        } catch {
            $ErrorMessage = $ErrorMessageRaw
        }
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

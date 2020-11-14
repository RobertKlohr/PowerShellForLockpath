function Invoke-LockpathRestMethod {
    <#
    .SYNOPSIS
        A wrapper around Invoke-WebRequest that understands the Lockpath API.

    .DESCRIPTION
        A wrapper around Invoke-WebRequest that understands the Lockpath API.

        Perform its operation with and without console status updates and also understands how to parse and handle
        errors from the REST calls.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER UriFragment
        The unique, tail-end, of the REST URI that indicates what REST action will be performed.

        This should not start with a leading "/".

    .PARAMETER Method
        The type of REST method being performed.

        This only supports a reduced set of the possible REST methods (delete, get, post).

    .PARAMETER AcceptHeader
        Specify the media type in the Accept header.

    .PARAMETER Body
        This optional parameter forms the body of a PUT or POST request.

        It will be automatically encoded to UTF8 and sent as Content Type: "application/json; charset=UTF-8"

    .PARAMETER ContentTypeHeader
        Specify the media type in the Content-Type header.

    .PARAMETER Description
        A friendly description of the operation being performed for logging and console display purposes.

    .PARAMETER InstanceName
        The URI of the API instance where all requests will be made.

    .PARAMETER InstancePort
        The portnumber of the API instance where all requests will be made.

    .PARAMETER InstancePortocol
        The protocol (http, https) of the API instance where all requests will be made.

    .PARAMETER Login
        The call being made is a login.

        The default behavior is to set the cookie in the web request from memory.  Using this switch gets the
        cookie from the login web request.

    .PARAMETER MethodContainsBody
        Valid HTTP methods for this API that will include a message body.

    .PARAMETER UserAgent
        The UserAgent string that is sent with each API request.

    .OUTPUTS
        [PSCustomObject] - The result of the REST operation, in whatever form it comes in.

    .EXAMPLE
        Invoke-LockpathRestMethod -UriFragment "GetUsers" -Method Get -Description "Get all users."

        Gets a list of system users.

    .NOTES

        Private helper method.

        This wraps Invoke-WebRequest as opposed to Invoke-RestMethod because we want access
        to the headers that are returned in the response, and Invoke-RestMethod drops those headers.

        This function is derived from the Invoke-RestMethod function in the PowerShellForGitHub module at
        https://aka.ms/PowerShellForGitHub
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true)]
        [String] $UriFragment,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [String] $Method,

        [Parameter(Mandatory = $true)]
        [String] $Description,

        [String] $AcceptHeader = $Script:configuration.acceptHeader,

        [String] $Body = $null,

        [String] $ContentTypeHeader = $Script:configuration.contentTypeHeader,

        [String] $InstanceName = $Script:configuration.instanceName,

        [UInt16] $InstancePort = $Script:configuration.instancePort,

        [String] $InstancePortocol = $Script:configuration.instanceProtocol,

        [Switch] $Login,

        [System.Collections.ArrayList] $MethodContainsBody = $Script:configuration.methodContainsBody,

        [String] $UserAgent = $Script:configuration.userAgent
    )

    # TODO do I need this line? can it be more generic to remove hardcoded protocol?
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # If the REST call is the login then redact the username and password sent in the body from the logs
    if ($Login) {
        Write-LockpathInvocationLog -RedactParameter Body -Confirm:$false -WhatIf:$false
    } else {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

        # Check to see if there is a valid authentication cookie and if not exit early.
        if ($Script:configuration.authenticationCookie.Name -eq 'INVALID') {
            Write-LockpathLog -Message 'The authentication cookie is not valid. You must first use Send-LockpathLogin to capture a valid authentication coookie.' -Level Warning
            break
        } else {
            $webSession = [Microsoft.PowerShell.Commands.WebRequestSession] @{}
            $cookie = [System.Net.Cookie] $Script:configuration.authenticationCookie
            $webSession.Cookies.Add($cookie)
        }
    }

    $headers = @{
        'Accept'     = $AcceptHeader
        'User-Agent' = $UserAgent
    }
    if ($Method -in $MethodContainsBody) {
        $headers.Add('Content-Type', $ContentTypeHeader)
    }

    $uri = "${InstancePortocol}://${InstanceName}:$InstancePort/$UriFragment"

    $params = [Hashtable]@{ }
    $params.Add('Uri', $uri)
    $params.Add('Method', $Method)
    $params.Add('Headers', $headers)
    $params.Add('TimeoutSec', $Script:configuration.webRequestTimeoutSec)

    #If the call is a login then capture the WebRequestSession object else send the WebRequestSession object.
    if ($Login) {
        $params.Add('Body', $Body)
        $params.Add('SessionVariable', 'webSession')
    } else {
        $params.Add('WebSession', $webSession)
    }
    Write-LockpathLog -Message $Description -Level Verbose
    if ($Method -in $methodContainsBody -and $Login -eq $false -and (-not [String]::IsNullOrEmpty($Body))) {
        $params.Add('Body', $Body)
        if ($Script:configuration.logRequestBody) {
            Write-LockpathLog -Message "Request includes a body: $Body" -Level Verbose
        } else {
            Write-LockpathLog -Message 'Request includes a body: <request body logging disabled>' -Level Verbose
        }
    }
    Write-LockpathLog -Message "Accessing [$Method] $uri [Timeout = $($Script:configuration.webRequestTimeoutSec)]" -Level Verbose
    try {
        $ProgressPreference = 'SilentlyContinue'
        #FIXME stopwatch testing
        $stopWatch = [system.diagnostics.stopwatch]::StartNew()
        $result = Invoke-WebRequest @params
        $stopWatch.Stop()
        $ProgressPreference = 'Continue'
        if ($Login) {
            # capture the authentication cookie for reuse in subsequent requests
            $Script:configuration.authenticationCookie = [Hashtable] @{
                'Domain' = $webSession.Cookies.GetCookies($uri).Domain
                'Name'   = $webSession.Cookies.GetCookies($uri).Name
                'Value'  = $webSession.Cookies.GetCookies($uri).Value
            }
        }
        # FIXME stopwatch testing
        # Write-Warning -Message $StopWatch.Elapsed.ToString()
        Write-LockpathLog -Message 'API request successful.' -Level Verbose
        return $result.Content
    } catch {
        if ($_.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            switch ($statusCode) {
                '400' {
                    $httpResponseDetails += 'The 400 (Bad Request) status code indicates that the server cannot or will not process the request due to something that is perceived to be a client error.'
                }
                '401' {
                    $httpResponseDetails = 'The 401 (Unauthorized) status code indicates that the request has not been applied because it lacks valid authentication credentials for the target resource. The user agent MAY repeat the request with a new or replaced Authorization header field.'
                }
                '403' {
                    $httpResponseDetails = 'The 403 (Forbidden) status code indicates that the server understood the request but refuses to authorize it. If authentication credentials were provided in the request, the server considers them insufficient to grant access.'
                }
                '404' {
                    $httpResponseDetails = 'The 404 (Not Found) status code indicates that the origin server did not find a current representation for the target resource or is not willing to disclose that one exists.'
                }
                '405' {
                    $httpResponseDetails = 'The 405 (Method Not Allowed) status code indicates that the method received in the request-line is known by the origin server but not supported by the target resource.'
                }
                '500' {
                    $httpResponseDetails = 'The 500 (Internal Server Error) status code indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.'
                }
                '504' {
                    $httpResponseDetails = 'The 504 (Gateway Timeout) status code indicates that the server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request.'
                }
                Default {
                    $httpResponseDetails = "Other Status Code $($_.Exception.Response.StatusCode.value__)."
                }
            }
            $exceptionOutput = [ordered]@{
                'statusCode'         = $statusCode
                #'exceptionMessage'   = $_.Exception.Message
                'exceptionDetails'   = $httpResponseDetails
                'scriptName'         = $_.InvocationInfo.ScriptName
                'scriptLine'         = $_.InvocationInfo.ScriptLineNumber
                'scriptOffestInLine' = $_.InvocationInfo.OffsetInLine
                'scriptStackTace'    = @($_.ScriptStackTrace.Split([System.Environment]::NewLine))
                'innerMessage'       = $_.ErrorDetails.Message
            }
            Write-LockpathLog -Message $($exceptionOutput | ConvertTo-Json -Depth $Script:configuration.jsonConversionDepth -Compress) -Exception $_ -Level Error
        } else {
            Write-LockpathLog -Exception $_ -Level Error
            throw
        }
    }
}

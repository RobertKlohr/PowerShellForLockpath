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
        [String] $Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Delete', 'Get', 'Post')]
        [String] $Method,

        [Parameter(Mandatory = $true)]
        [ValidateSet('AssessmentService', 'ComponentService', 'PrivateHelper', 'Public', 'ReportService', 'SecurityService')]
        [String] $Service,

        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[a-zA-Z0-9]+$')]
        [String] $UriFragment,

        [ValidateSet('application/json', 'application/xml')]
        [String] $AcceptHeader = $Script:LockpathConfig.acceptHeader,

        [String] $Body = $null,

        [ValidateSet('application/json', 'application/xml')]
        [String] $ContentTypeHeader = $Script:LockpathConfig.contentTypeHeader,

        [ValidatePattern('^(?!https?:).*')]
        [String] $InstanceName = $Script:LockpathConfig.instanceName,

        [ValidateRange(0, 65535)]
        [UInt16] $InstancePort = $Script:LockpathConfig.instancePort,

        [ValidatePattern('^https?$')]
        [String] $InstancePortocol = $Script:LockpathConfig.instanceProtocol,

        [System.Collections.ArrayList] $MethodContainsBody = $Script:LockpathConfig.methodContainsBody,

        [String] $Query = $null,

        [String] $UserAgent = $Script:LockpathConfig.userAgent

    )
    # Check to see if the calling function was the login and set the Login flag
    If (((Get-Variable -Name MyInvocation -Scope 1 -ValueOnly).MyCommand.Name) -eq 'Send-LockpathLogin') {
        $Login = $true
    } else {
        $Login = $false
    }


    $level = 'Verbose'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    # FIXME need to reconcile this variable
    # $service = 'PrivateHelper'

    # TODO do I need this line? can it be more generic to remove hardcoded protocol?
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # If the REST call is the login then redact the username and password sent in the body from the logs
    if ($Login) {
        # Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service 'PrivateHelper' -RedactParameter Body
        Write-Verbose 'Executing Invoke-LockpathRestMethod'
    } else {
        Write-Verbose 'Executing Invoke-LockpathRestMethod'
        # Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -Service 'PrivateHelper'

        # Check to see if there is a valid authentication cookie and if not exit early.
        if ($Script:LockpathConfig.authenticationCookie.Name -eq 'INVALID') {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'The authentication cookie is not valid. You must first use Send-LockpathLogin to capture a valid authentication coookie.' -Level $level -FunctionName $functionName -Service PrivateHelper
            break
        } else {
            $webSession = [Microsoft.PowerShell.Commands.WebRequestSession] @{}
            $cookie = [System.Net.Cookie] $Script:LockpathConfig.authenticationCookie
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

    # FIXME remove once all functions are updated and tested
    # $uri = "${InstancePortocol}://${InstanceName}:$InstancePort/$UriFragment"

    $uri = "${InstancePortocol}://${InstanceName}:$InstancePort/$Service/$UriFragment$Query"

    $params = [Hashtable]@{ }
    $params.Add('Uri', $uri)
    $params.Add('Method', $Method)
    $params.Add('Headers', $headers)
    $params.Add('TimeoutSec', $Script:LockpathConfig.webRequestTimeoutSec)

    #If the call is a login then capture the WebRequestSession object else send the WebRequestSession object.
    if ($Login) {
        $params.Add('Body', $Body)
        $params.Add('SessionVariable', 'webSession')
    } else {
        $params.Add('WebSession', $webSession)
    }


    # FIXME add write-versbose or write-debug lines to replace the intermediate logging that is now written to file

    try {
        $ProgressPreference = 'SilentlyContinue'
        #FIXME stopwatch testing
        $stopWatch = [system.diagnostics.stopwatch]::StartNew()


        if ($Method -in $methodContainsBody -and $Login -eq $false -and (-not [String]::IsNullOrEmpty($Body))) {
            $params.Add('Body', $Body)
            if ($Script:LockpathConfig.logRequestBody) {
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Request includes a body: $Body" -Level $level -FunctionName $functionName -Service PrivateHelper
            } else {
                Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Request includes a body: <request body logging disabled>' -Level $level -FunctionName $functionName -Service PrivateHelper
            }
        }


        [Microsoft.PowerShell.Commands.WebResponseObject] $result = Invoke-WebRequest @params

        Write-Verbose $result

        $stopWatch.Stop()
        $ProgressPreference = 'Continue'
        if ($Login) {
            Export-LockpathAuthenticationCookie -Cookie $webSession.Cookies.GetCookies($uri) -Uri $uri
        }
        # FIXME stopwatch testing
        # Write-Warning -Message $StopWatch.Elapsed.ToString()

        # FIXME combine the 4 log entries below into a single log CEF entry

        # Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $Description -Level $level -FunctionName $functionName -Service PrivateHelper

        # if ($Method -in $methodContainsBody -and $Login -eq $false -and (-not [String]::IsNullOrEmpty($Body))) {
        #     $params.Add('Body', $Body)
        #     if ($Script:LockpathConfig.logRequestBody) {
        #         Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Request includes a body: $Body" -Level $level -FunctionName $functionName -Service PrivateHelper
        #     } else {
        #         Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'Request includes a body: <request body logging disabled>' -Level $level -FunctionName $functionName -Service PrivateHelper
        #     }
        # }

        # Write-LockpathLog -Confirm:$false -WhatIf:$false -Message "Accessing [$Method] $uri [Timeout = $($Script:LockpathConfig.webRequestTimeoutSec)]" -Level $level -FunctionName $functionName -Service PrivateHelper

        # Write-LockpathLog -Confirm:$false -WhatIf:$false -Message 'API request successful.' -Level $level -FunctionName $functionName -Service PrivateHelper

        return $result.Content
    } catch {
        if ($_.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            # FIXME update the switch with use information
            # FIXME comment out the status codes not currently implemented by the API as place holders (need to
            # test and validate)
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

            # FIXME pass this information back to the calling function where the write-lockpathlog call will be made
            # Write-Error -ErrorAction Stop -ErrorRecord $_
            # Write-LockpathLog -Confirm:$false -WhatIf:$false -Message $($_.ErrorDetails.Message | ConvertFrom-Json | Select-Object -ExpandProperty Message) -ErrorRecord $_ -Level $level -FunctionName $functionName -Service 'PrivateHelper'

            # TODO the following will be more useful once the conversion to CEF format
            # $exceptionOutput = [ordered]@{
            #     'statusCode'         = $statusCode
            #     'exceptionMessage'   = $_.ErrorDetails.Message | ConvertFrom-Json | Select-Object -ExpandProperty Message
            #     'exceptionDetails'   = $httpResponseDetails
            #     'scriptName'         = $_.InvocationInfo.ScriptName
            #     'scriptLine'         = $_.InvocationInfo.ScriptLineNumber
            #     'scriptOffestInLine' = $_.InvocationInfo.OffsetInLine
            #     'scriptStackTace'    = @($_.ScriptStackTrace.Split([System.Environment]::NewLine))
            # }
            # Write-Error -ErrorAction stop -Exception $_.Exception
            Write-Error -ErrorAction stop -ErrorRecord $_
        } else {
            Write-LockpathLog -Confirm:$false -WhatIf:$false -Level $level -FunctionName $functionName -Service PrivateHelper -ErrorRecord $_
            Write-Error 'non-webresponse error' -ErrorAction stop

        }
    }
}

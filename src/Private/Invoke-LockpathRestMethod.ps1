# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

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

    #TODO add should process
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [String] $Description,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet('Delete', 'Get', 'Post')]
        [String] $Method,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet('AssessmentService', 'ComponentService', 'PrivateHelper', 'Public', 'ReportService', 'SecurityService')]
        [String] $Service,

        [Parameter(
            Mandatory = $true
        )]
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
    $level = 'Debug'
    $functionName = ($PSCmdlet.CommandRuntime.ToString())
    # In most cmdlets the $service is set here but in this module it is used for building the API
    # $uri and so needs to be set below.
    # $logParameters.service = 'PrivateHelper'

    $logParameters = [ordered]@{
        'FunctionName' = $functionName
        'Level'        = $level
        'Message'      = "Executing cmdlet: $functionName"
        'Service'      = $Service
        'Result'       = "Executing cmdlet: $functionName"
    }

    $shouldProcessTarget = $Description
    if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
        # Check to see if the calling function was the login and set the Login flag and redact the
        # message body so the password is not logged.
        If (((Get-Variable -Name MyInvocation -Scope 1 -ValueOnly).MyCommand.Name) -eq 'Connect-Lockpath') {
            $Login = $true
            Write-LockpathInvocationLog @logParameters -RedactParameter 'Body'
        } else {
            $Login = $false
            Write-LockpathInvocationLog @logParameters
        }

        # Check to see if there is a valid cookie and create the websession, if not exit early
        if ((-not $login) -and ($Script:LockpathConfig.authenticationCookie.Name -eq 'INVALID')) {
            $logParameters.message = 'Failed: The authentication cookie is not valid. You must first use Send-LockpathLogin to capture a valid authentication coookie.'
            Write-LockpathLog @logParameters
            break
        } elseif (-not $login) {
            $webSession = [Microsoft.PowerShell.Commands.WebRequestSession] @{}
            # $webSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $cookie = [System.Net.Cookie] @{}
            # $cookie = New-Object System.Net.Cookie
            $cookie.Name = $Script:LockpathConfig.authenticationCookie.Name[0]
            $cookie.Domain = $Script:LockpathConfig.authenticationCookie.Domain[0]
            $cookie.Value = $Script:LockpathConfig.authenticationCookie.Value[0]
            # $cookie = [System.Net.Cookie] $Script:LockpathConfig.authenticationCookie
            $webSession.Cookies.Add($cookie)
        }

        # Set the headers
        $headers = @{
            'Accept'     = $AcceptHeader
            'User-Agent' = $UserAgent
        }
        if ($Method -in $MethodContainsBody) {
            $headers.Add('Content-Type', $ContentTypeHeader)
        }

        # Build the URI
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
        #TODO reduce the output logging to one line per request, currently 2 are written on a failure
        try {
            if ($Method -in $methodContainsBody -and $Login -eq $false -and (-not [String]::IsNullOrEmpty($Body))) {
                $params.Add('Body', $Body)
                if ($Script:LockpathConfig.logRequestBody) {
                    $logParameters.Message = 'Request includes a body.'
                    try {
                        $Body = (ConvertFrom-Json $Body) | ConvertTo-Json -Compress
                        $logParameters.result = $Body
                    } catch {
                        $logParameters.Level = 'Error'
                        $logParameters.Message = 'Failed: to convert request body.'
                        $logParameters.Result = $_.Exception.Message
                    } finally {
                        Write-LockpathLog @logParameters
                    }
                } else {
                    $logParameters.Message = 'Request includes a body: <message body logging disabled>.'
                    Write-LockpathLog @logParameters
                }
            }

            #! Here is the web call
            [Microsoft.PowerShell.Commands.WebResponseObject] $result = Invoke-WebRequest @params

            if ($Login -and ($result.Content -eq 'true')) {
                Export-LockpathAuthenticationCookie -CookieCollection $webSession.Cookies.GetCookies($uri)
            }

            $logParameters.Message = 'Success: ' + $shouldProcessTarget
        } catch {
            $logParameters.Level = 'Error'
            $logParameters.Message = "Failed: $Description"
            $logParameters.Result = $_.Exception.Message
            if ($_.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
                $statusCode = $_.Exception.Response.StatusCode.value__
                switch ($statusCode) {
                    '400' {
                        $httpResponseDetails += 'The 400 (Bad Request) status code indicates that the server cannot or will not process the request due to something that is perceived to be a client error.'
                    }
                    '404' {
                        $httpResponseDetails = 'The 404 (Not Found) status code indicates that the origin server did not find a current representation for the target resource or is not willing to disclose that one exists.'
                    }
                    '500' {
                        $httpResponseDetails = 'The 500 (Internal Server Error) status code indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.'
                    }
                    Default {
                        $httpResponseDetails = "Other Status Code $($_.Exception.Response.StatusCode.value__)."
                    }
                }
                $logParameters.Message = "Failed: Status code $statusCode."
                $logParameters.Result = $_.Exception.Message + $httpResponseDetails
            }
        } finally {
            Write-LockpathLog @logParameters
        }
        return $result.content.ToString()
    }
}

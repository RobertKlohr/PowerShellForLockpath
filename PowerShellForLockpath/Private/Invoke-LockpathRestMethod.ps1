function Invoke-LockpathRestMethod {
    <#
    .SYNOPSIS
        A wrapper around Invoke-WebRequest that understands the Lockpath API.

    .DESCRIPTION
        A very heavy wrapper around Invoke-WebRequest that understands the Lockpath API and
        how to perform its operation with and without console status updates.  It also
        understands how to parse and handle errors from the REST calls.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER UriFragment
        The unique, tail-end, of the REST URI that indicates what REST action will
        be performed.  This should not start with a leading "/".

    .PARAMETER Method
        The type of REST method being performed.  This only supports a reduced set of the
        possible REST methods (delete, get, post).

    .PARAMETER AcceptHeader
        Specify the media type in the Accept header.  Different types of commands may require
        different media types.

    .PARAMETER Body
        This optional parameter forms the body of a PUT or POST request. It will be automatically
        encoded to UTF8 and sent as Content Type: "application/json; charset=UTF-8"

    .PARAMETER Description
        A friendly description of the operation being performed for logging and console
        display purposes.

    .PARAMETER InstanceName
        The URI of the API instance where all requests will be made.

    .PARAMETER InstancePort
        The portnumber of the API instance where all requests will be made.

    .PARAMETER InstancePortocol
        The protocol (http, https) of the API instance where all requests will be made.

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

        [String] $AcceptHeader = $(Get-LockpathConfiguration -Name 'acceptHeader'),

        [String] $Body = $null,

        [String] $InstanceName = $(Get-LockpathConfiguration -Name 'instanceName'),

        [UInt16] $InstancePort = $(Get-LockpathConfiguration -Name 'instancePort'),

        [String] $InstancePortocol = $(Get-LockpathConfiguration -Name 'instanceProtocol'),

        [String[]] $MethodContainsBody = $(Get-LockpathConfiguration -Name 'MethodContainsBody'),

        [String] $UserAgent = $(Get-LockpathConfiguration -Name 'userAgent')
    )

    # If the REST call is the login then redact the username and password sent in the body from the logs
    if ($UriFragment -eq 'SecurityService/Login') {
        Write-LockpathInvocationLog -RedactParameter Body -Confirm:$false -WhatIf:$false
    } else {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    $headers = @{
        'Accept'     = $AcceptHeader
        'User-Agent' = $UserAgent
    }

    if ($Method -in $MethodContainsBody) {
        $headers.Add('Content-Type', 'application/json')
    }

    $url = "${InstancePortocol}://${InstanceName}:$InstancePort/$UriFragment"

    try {
        Write-LockpathLog -Message $Description -Level Verbose
        Write-LockpathLog -Message "Accessing [$Method] $url [Timeout = $(Get-LockpathConfiguration -Name WebRequestTimeoutSec))]" -Level Verbose

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
            $params.Add('Body', $Body)
            if (Get-LockpathConfiguration -Name LogRequestBody) {
                Write-LockpathLog -Message "Request includes a body: $Body" -Level Verbose
            } else {
                Write-LockpathLog -Message 'Request includes a body: <logging disabled>' -Level Verbose
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
        return $result.Content

    } catch {
        switch ($_.Exception.Response.StatusCode.value__) {
            '400' {
                $httpResponseDetails += 'The 400 (Bad Request) status code indicates that the server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing)..'
            }
            '401' {
                $httpResponseDetails = 'The 401 (Unauthorized) status code indicates that the request has not been applied because it lacks valid authentication credentials for the target resource...The user agent MAY repeat the request with a new or replaced Authorization header field.'
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
                $httpResponseDetails = 'Other Status Code.'
            }
        }
        if ($_.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            $exceptionOutput = [ordered]@{
                'exceptionMessage'   = $_.Exception.Message
                'exceptionDetails'   = $httpResponseDetails
                'scriptName'         = $_.InvocationInfo.ScriptName
                'scriptLine'         = $_.InvocationInfo.ScriptLineNumber
                'scriptOffestInLine' = $_.InvocationInfo.OffsetInLine
                'scriptStackTace'    = @($_.ScriptStackTrace.Split([System.Environment]::NewLine))
                'innerMessage'       = $_.ErrorDetails.Message
            }
            Write-LockpathLog -Message $($exceptionOutput | ConvertTo-Json -Depth 10 -Compress) -Level Error
        } else {
            Write-LockpathLog -Exception $_ -Level Error
        }
    }
}

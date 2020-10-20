function Send-LockpathLogin {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    #TODO add parameter  and extra code to easily override the instance in the configuration file
    param()

    Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false

    $credential = Get-LockpathCredential
    $hashBody = [ordered]@{
        'username' = $credential.username
        'password' = $credential.GetNetworkCredential().Password
    }

    $params = @{
        'UriFragment' = 'SecurityService/Login'
        'Method'      = 'POST'
        'Description' = "Sending login to $($script:configuration.instanceName) with Username $($credential.username) and Password: [redacted]"
        'Body'        = (ConvertTo-Json -InputObject $hashBody)
    }

    $null = Invoke-LockpathRestMethod @params -Confirm:$false -WhatIf:$false

    # TODO update code to capture the auth cookie on successful login and use this cookie on subsequent connections
    # $requestUrl = "http://10.140.2.182"
    # $username = "user1"
    # $password = "123"
    # $helperSession = Invoke-WebRequest -Uri ($requestUrl + '?accountId=' + $username + '&password=' + $password) -Method Get -SessionVariable websession
    # $cookies = $websession.Cookies.GetCookies($requestUrl)
    # $authCookie = $cookies | Where-Object { $_.Name -eq '.ASPXAUTH' } ##For authentication to the web service we need this cookie

    # function getAlertsThisObjectCanTrigger($cookie, $requestUrl, $objectUri)
    # {
    #     $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    #     $session.Cookies.Add($cookie); ##add the auth. cookie to the session
    #     $RequestUri = $requestUrl + "/api/AllAlertThisObjectCanTrigger/GetAlerts"
    #     $payload = '{"AlertDefId":1,"EntityName":"Orion.Nodes","TriggeringObjectEntityUri":"' + $objectUri + '","CurrentPageIndex":0,"PageSize":"100"}'
    #     $response = Invoke-WebRequest -Uri $RequestUri -Body $payload -Method Post -ContentType application/json -WebSession $session
    #     $contentObject = $response.Content | ConvertFrom-Json
    #     [System.Array]$alertList = $null
    #     $contentObject.DataTable.Rows | % { $alertList += $_[0] } ##Filter just alert name
    #     return $alertList
    # }

}

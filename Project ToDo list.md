* #TODO Update the descriptions on each function to highlight API calls to get each parameter. (see Get-LockpathRecordAttachment)
* #TODO Rework configuration settings.
* #TODO add switch for each call for serialized vs. raw format for content returned json vs. PsCustomObject
* #TODO background looping job for calling Lockpath Ping API call to keep session alive. Look at Keep Alive Script
* #TODO check quotes single (default) vs. double (only around variables)
* #TODO set $result variable in each function to an empty variable of the correct type at the beginning of the function
* #TODO see where it would be useful to have ArgumentCompleter attributes configured
* #TODO create a module to build searchcriteria items (API guide chapter 4.)
* #TODO ensure that all functions that support the pipeline include ValueFromPipelineByPropertyName=$true
* #TODO Document in examples sectons having a filter with multiple criteria. ### (@{Shortname = "AccountType";
FilterType = 5; Value = 1 }, @{ Shortname = "Deleted"; FilterType = 5; Value ="true" })

* #TODO update login code to capture the auth cookie on successful login and use this cookie on subsequent
  connections instead of capturing and reusing the websession object

$requestUrl = "http://10.140.2.182"
$username = "user1"
$password = "123"
$helperSession = Invoke-WebRequest -Uri ($requestUrl + '?accountId=' + $username + '&password=' + $password) -Method Get -SessionVariable websession
$cookies = $websession.Cookies.GetCookies($requestUrl)
$authCookie = $cookies | Where-Object { $_.Name -eq '.ASPXAUTH' } ##For authentication to the web service we need this cookie

function getAlertsThisObjectCanTrigger($cookie, $requestUrl, $objectUri)
{
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.Cookies.Add($cookie); ##add the auth. cookie to the session
    $RequestUri = $requestUrl + "/api/AllAlertThisObjectCanTrigger/GetAlerts"
    $payload = '{"AlertDefId":1,"EntityName":"Orion.Nodes","TriggeringObjectEntityUri":"' + $objectUri + '","CurrentPageIndex":0,"PageSize":"100"}'
    $response = Invoke-WebRequest -Uri $RequestUri -Body $payload -Method Post -ContentType application/json -WebSession $session
    $contentObject = $response.Content | ConvertFrom-Json
    [System.Array]$alertList = $null
    $contentObject.DataTable.Rows | % { $alertList += $_[0] } ##Filter just alert name
    return $alertList
}

* #TODO add badges to readme.md file.  See examples from PowershellForGitHub below.

[![[GitHub version]](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub.svg)](https://badge.fury.io/gh/microsoft%2FPowerShellForGitHub)
[![Build
status](https://dev.azure.com/ms/PowerShellForGitHub/_apis/build/status/PowerShellForGitHub-CI?branchName=master)](https://dev.azure.com/ms/PowerShellForGitHub/_build/latest?definitionId=109&branchName=master)

function Get-LockpathApiUserDetails {
    <#
    .SYNOPSIS
        Returns all user details for the user making the API request.

    .DESCRIPTION
        Returns all user details for the user making the API request.

        Combines Get-LockpathUserCount, Get-LockpathUsers and Get-LockpathUser.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .EXAMPLE
        Get-LockpathApiUser

    .INPUTS
        None.

    .OUTPUTS
        String

    .NOTES
        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param()

    Write-LockpathInvocationLog -Service SecurityService

    if ($PSCmdlet.ShouldProcess("Getting users with body: $([environment]::NewLine) $($params.Body)", $($params.Body), 'Getting groups with body:')) {
        # check to see if the username is set in the login credential and exit early if it is null
        Import-LockpathCredential
        if ($null -eq $Script:LockpathConfig.credential.UserName) {
            Write-LockpathLog -Message 'No API username is present in the configuration. Use Set-LockpathCredential to set the API credential.' -Level Warning -Service SecurityService
            return
        }

        # get total users on system to set PageSize parameter for Get-LockpathUsers
        $userCount = Get-LockpathUserCount

        # get a list of all users on the system  We can filter for only active accounts to speed things up
        $users = Get-LockpathUsers -PageIndex 0 -PageSize $userCount -Filter @{'Field' = @{'ShortName' = 'Active' }; 'FilterType' = '5'; 'Value' = 'true' } | ConvertFrom-Json -Depth $Script:LockpathConfig.jsonConversionDepth -AsHashtable

        # find the Id of the user making this API call
        $apiUser = $users | Where-Object { $_.Username -eq $Script:LockpathConfig.credential.UserName }

        # get details for the user account matching the one used to authenticate this API call
        $apiUserDetails = Get-LockpathUser -UserId $apiUser.Id

        Return $apiUserDetails

    } else {
        Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Service SecurityService
    }
}

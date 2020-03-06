function Send-LpPing {

    <#
        .SYNOPSIS
            Refreshes a valid Keylight Platform session.

        .DESCRIPTION
            Refreshes a valid Keylight Platform session.

        .PARAMETER
            None

        .EXAMPLE
            Test-LpConnection

        .INPUTS
            None

        .OUTPUTS
            String

        .NOTES
            Refreshes a valid Keylight Platform session.
            URL: http://[instance-name]:[port]/SecurityService/Ping
            Method: GET
            Input: No input allowed
            Permissions: The account that is used to log into the application must have access to the Keylight API.

        .LINK
            Online Version: https://github.com/RjKGitHub/PowerShellForLockpath/

        .COMPONENT
            SecurityService
            Lockpath

        .ROLE
            The user role for the help topic.
            This content appears when the Get-Help command includes the Role parameter of Get-Help.

        .FUNCTIONALITY
            The intended use of the function.
            This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>

    [CmdletBinding()]
    [OutputType([Boolean])]

    #TODO: change $config to string URL
    param(
        # Lockpath session object.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]
        $WebSession,
        # Lockpath configuration object.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]
        $Config
    )

    begin {
        $Params = @{
            Config     = $Config
            WebSession = $WebSession
            HttpMethod = 'GET'
            UrlPath    = "/SecurityService/Ping"
        }
    }

    process {
        try {
            Invoke-LpRestMethod @Params | Write-Output -ErrorAction Stop
        } catch {
            #$ErrorMessage = $_.ErrorDetails.Message | ConvertFrom-Json | Select -ExpandProperty Message
            $ErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                (New-Object Exception("Exception executing the Invoke-RestMethod cmdlet. $($_.ErrorDetails.Message)")),
                'Invoke-RestMethod',
                [System.Management.Automation.ErrorCategory]$_.CategoryInfo.Category,
                $parameters
            )
            $ErrorRecord.CategoryInfo.Reason = $_.CategoryInfo.Reason;
            $ErrorRecord.CategoryInfo.Activity = $_.InvocationInfo.InvocationName;
            $PSCmdlet.ThrowTerminatingError($ErrorRecord);
        }
    }

    end {
    }
}

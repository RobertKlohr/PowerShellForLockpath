function New-LpSession2 () {
    <#
        .SYNOPSIS
            Login to Lockpath.

        .DESCRIPTION
            Accepts an account username and password, verifies them within Keylight and provides an encrypted cookie that
can be used to authenticate additional API transactions.

        .EXAMPLE
            New-LpSession -URL "https://test/" -Session $LpSession

        .INPUTS
            The Microsoft .NET Framework types of objects that can be piped to the function or script.
            You can also include a description of the input objects.

        .OUTPUTS
            The .NET Framework type of the objects that the cmdlet returns.
            You can also include a description of the returned objects.

        .NOTES
            Additional information about the function or script.

        .LINK
            Online Version: https://github.com/RobertKlohr/PowerShellForLockpath/

        .COMPONENT
            SecurityServices
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

    #    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "", Justification = "Password must be passed on the command line and send in the body of the POST in plaintext")]
    param (
        # URL to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [uri]
        $Url = $LpUrl,
        # Web session with authentication cookie set.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session = $LpSession
    )

    begin {
        # $Password = (New-Object -TypeName PSCredential -ArgumentList @('user', ($LockpathConfiguration.Password | ConvertTo-SecureString))).GetNetworkCredential().Password,

        #        $Headers = New-Object "System.Collections.Generic.Dictionary[ [String], [String] ]"
        $Headers = @{
            "Accept"       = "application/json"
            "Content-Type" = "application/json"
            "User-Agent"   = "PowerShell/" + $PSVersionTable.PSVersion.ToString(2) + " Lockpath/API"
        }
        $Parameters = @{
            Body            = @{
                "username" = $LpConfig.Username
                "password" = (New-Object PSCredential "user", ($LpConfig.Password | ConvertTo-SecureString)).GetNetworkCredential().Password
            } | ConvertTo-Json
            Headers         = $Headers
            Method          = "POST"
            Uri             = $LpConfig.Uri + "/SecurityService/Login"
            SessionVariable = "RestSession"
        }
    }

    process {
        try {
            $Response = Invoke-RestMethod @Parameters -ErrorAction Stop
        } catch {
            # Get the message returned from the server which will be in JSON format
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
        Set-Variable -Name LpUrl -Value $LpConfig.Uri -Scope "Global"
        Set-Variable -Name LpSession -Value $RestSession -Scope "Global"
    }

    end {
        return $Response
    }
}

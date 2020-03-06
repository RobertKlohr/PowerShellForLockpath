function Get-LpWorkflows {

    <#
        .SYNOPSIS
            A brief description of the function or script.
            This keyword can be used only once in each topic.

        .DESCRIPTION
            A detailed description of the function or script.
            This keyword can be used only once in each topic.

        .PARAMETER <parameter-name>
            The description of a parameter. Add a keyword for each parameter in the function or script syntax.

            Type the parameter name on the same line as the keyword. Type the parameter description on the lines following the keyword.

            Windows PowerShell interprets all text between the keyword line and the next keyword or the end of the comment block as part of the parameter description.
            The description can include paragraph breaks.

            The Parameter keywords can appear in any order in the comment block, but the function or script syntax determines the order in which the parameters (and their descriptions) appear in help topic.
            To change the order, change the syntax.

            You can also specify a parameter description by placing a comment in the function or script syntax immediately before the parameter variable name.
            If you use both a syntax comment and a Parameter keyword, the description associated with the Parameter keyword is used, and the syntax comment is ignored.

        .EXAMPLE
            A sample command that uses the function or script, optionally followed by sample output and a description.
            Repeat this keyword for each example.

        .INPUTS
            The Microsoft .NET Framework types of objects that can be piped to the function or script.
            You can also include a description of the input objects.

        .OUTPUTS
            The .NET Framework type of the objects that the cmdlet returns.
            You can also include a description of the returned objects.

        .NOTES
            Additional information about the function or script.

        .LINK
         Online Version: https://github.com/RjKGitHub/PowerShellForLockpath/

        .COMPONENT
            The technology or feature that the function or script uses, or to which it is related.
            This content appears when the Get-Help command includes the Component parameter of Get-Help.

        .ROLE
            The user role for the help topic.
            This content appears when the Get-Help command includes the Role parameter of Get-Help.

        .FUNCTIONALITY
            The intended use of the function.
            This content appears when the Get-Help command includes the Functionality parameter of Get-Help.
    #>

    #TODO: Complete Initial function setup
    [CmdletBinding()]
    [OutputType([int])]

    param(
        # Full URi to the Lockpath instance.
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        $Session,
        # Alias of the component
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $WorkflowAlias
    )

    begin {
        $ResourcePath = "/ComponentService/GetWorkflows"
        $Method = 'GET'
        $Query = '?componentAlias=' + $WorkflowAlias

        $Parameters = @{
            Uri             = $LpUrl + $ResourcePath + $Query
            WebSession      = $LpSession
            Method          = $Method
        }
    }

    process {
        try {
            $Response = Invoke-RestMethod @parameters -ErrorAction Stop
        }
        catch {
            #TODO: create error handling cmdlet to replace this work
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
    }

    end {
        Return $Response
    }
}
function Set-LockpathGroup {
    <#
    .SYNOPSIS
        Updates a group.

    .DESCRIPTION
        Updates a group.  All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

        The list of attributes must include the Id field and the group Id as the value for the group being updated.

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'}

    .EXAMPLE
        Set-LockpathGroup -Attributes @{'Id' = '7'; 'Name' = 'API Update Group'; 'Users' = @(@{'Id'= '6'},@{'Id'= '10'}}

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateGroup

        The authentication account must have Read and Update Administrative Access permissions to administer groups.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
    #>

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Array] $Attributes
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {

        $GroupId = $Attributes.Id

        $params = @{
            'UriFragment' = 'SecurityService/UpdateGroup'
            'Method'      = 'POST'
            'Description' = "Updating group with Id: $GroupId and values $($Attributes | ConvertTo-Json -Depth 10 -Compress)"
            'Body'        = $Attributes | ConvertTo-Json -Depth 10
        }
        if ($PSCmdlet.ShouldProcess("Updating group with group Id $($GroupId) and settings: $([environment]::NewLine) $($params.Body)", "$($params.Body)", "Updating group with group with Id $($GroupId) and settings:")) {
            [String] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

function Get-LockpathFieldList {
    <#
.SYNOPSIS
    Returns detail field listing for a given component.
.DESCRIPTION
    Returns detail field listing for a given component. A component is a user-defined data object such as a
    custom content table. The component Id may be found by using Get-LockpathComponentList. Assessments field type are not visible in this list.
.PARAMETER ComponentId
    Specifies the Id number of the component as a positive integer.
.EXAMPLE
    Get-LockpathFieldList -ComponentId 2
.EXAMPLE
    Get-LockpathFieldList 2
.EXAMPLE
    2 | Get-LockpathFieldList
.EXAMPLE
    2,3,6 | Get-LockpathFieldList
.EXAMPLE
    $componentObject | Get-LockpathFieldList
    If $componentObject has an property called ComponentId that value is automatically passed as a parameter.
.INPUTS
    System.Uint32.
.OUTPUTS
    System.String.
.NOTES
    The authentication account must have Read General Access permissions for the specific component.
.LINK
    https://github.com/RobertKlohr/PowerShellForLockpath
#>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true)]
        [Alias("Id")]
        [ValidateRange("Positive")]
        [int] $ComponentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetFieldList?id=$ComponentId"
            'Method'      = 'GET'
            'Description' = "Getting component with Id: $ComponentId"
        }
        if ($PSCmdlet.ShouldProcess("Getting field list for component with Id: $([environment]::NewLine) $ComponentId", $ComponentId, 'Getting field list for component with Id:')) {
            $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

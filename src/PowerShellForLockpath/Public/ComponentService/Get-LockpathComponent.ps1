function Get-LockpathComponent {
    <#
    .SYNOPSIS
  Returns information about a component specified by its Id.

    .DESCRIPTION
        Returns information about a component specified by its Id.

        Returns the Id, Name, SystemName and ShortName for the component.

        The Git repo for this module can be found here: https://github.com/RobertKlohr/PowerShellForLockpath

    .PARAMETER ComponentId
        Specifies the Id number of the component as a positive integer.

  The component Id may be found by using Get-LockpathComponentList.

    .EXAMPLE
        Get-LockpathComponent -ComponentId 2

    .EXAMPLE
        Get-LockpathComponent 2

    .INPUTS
        System.Uint32

    .OUTPUTS
        {
            "Id": 10050, "Name": "Incident Reports",
            "SystemName": "LPIncidentReports",
            "ShortName": "LPIncidentReports"
        }

    .NOTES
        The authentication account must have Read General Access permissions for the specific component.

    .LINK
        https://github.com/RobertKlohr/PowerShellForLockpath/wiki
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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [ValidateRange('Positive')]
        [uint] $ComponentId
    )

    begin {
        Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false
    }

    process {
        $params = @{
            'UriFragment' = "ComponentService/GetComponent?id=$ComponentId"
            'Method'      = 'GET'
            'Description' = "Getting component with Id: $ComponentId"
        }

        if ($PSCmdlet.ShouldProcess("Getting component with Id: $([environment]::NewLine) $ComponentId", $ComponentId, 'Getting component with Id:')) {
            [string] $result = Invoke-LockpathRestMethod @params -Confirm:$false
            return $result
        } else {
            Write-LockpathLog -Message "$($PSCmdlet.CommandRuntime.ToString()) ShouldProcess confirmation was denied." -Level Verbose -Confirm:$false -WhatIf:$false
        }
    }

    end {
    }
}

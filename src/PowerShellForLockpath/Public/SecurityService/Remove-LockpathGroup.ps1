function Remove-LockpathGroup {
    #FIXME Update to new coding standards
    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $GroupId
    )

    begin {
        #TODO call get group to add group name to log
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = 'SecurityService/DeleteGroup'
            'Method'      = 'DELETE'
            'Description' = "Deleting Group with Group Id: $GroupId"
            'Body'        = $GroupId | ConvertTo-Json
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}

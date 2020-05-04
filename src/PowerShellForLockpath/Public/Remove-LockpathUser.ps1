function Remove-LockpathUser {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $UserId
    )

    begin {
        #TODO call get record attachment to user's name into the log.
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = 'SecurityService/DeleteUser'
            'Method'      = 'DELETE'
            'Description' = "Deleting User with User Id: $UserId"
            'Body'        = $UserId | ConvertTo-Json
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}

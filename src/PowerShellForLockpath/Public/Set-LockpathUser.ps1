#TODO Ensure $Update arrary is converted into correctly formatted JSON
function Set-LockpathUser {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Methods called within here make use of PSShouldProcess, and the switch is passed on to them inherently.')]

    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $UserId,

        [array] $Update = ''
    )

    begin {
        Write-LockpathInvocationLog
        $params = @{ }
        $params = @{
            'UriFragment' = "SecurityService/UpdateUser"
            'Method'      = 'POST'
            'Description' = "Updating User with User Id: $UserId"
            'Body'        = [ordered]@{
                'Id' = $UserId
                'filters' = $Update
            } | ConvertTo-Json -Depth 10
        }
    }

    process {
        $result = Invoke-LockpathRestMethod @params
    }

    end {
        return $result
    }
}
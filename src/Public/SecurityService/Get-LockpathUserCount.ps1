# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Get-LockpathUserCount {
    <#
    .SYNOPSIS
        Returns the number of users.

    .DESCRIPTION
        Returns the number of users. The count does not include Deleted users and can include non-Lockpath user
        accounts, such as Vendor Contacts.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Filter
        The filter parameters the groups must meet to be included.

        Remove the filter to return a list of all groups.

    .EXAMPLE
        Get-LockpathUserCount

    .EXAMPLE
        Get-LockpathUserCount -Filter @(@{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='5'; 'Value'='2'})

        Returns a set of users with the account type of Vendor.

    .EXAMPLE
        Get-LockpathUserCount -Filter @(@{'Field'= @{'ShortName'='Deleted'}; 'FilterType'='5'; 'Value'='true'},@{'Field'= @{'ShortName'='AccountType'}; 'FilterType'='5'; 'Value'='1'})

        Returns a set of users with the account type of vendor and status of Inactive.

    .INPUTS
        System.Array

    .OUTPUTS
        System.Int32

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/GetUserCount

        The authentication account must have Read Administrative Access permissions to administer users.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Low',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.Int32])]

    param(
        #TODO add switches for common queries i.e., Deleted, Active, Vendor, AccountType

        [Parameter(
            ParameterSetName = 'Active',
            Mandatory = $false
        )]
        [Parameter(
            ParameterSetName = 'Deleted',
            Mandatory = $false
        )]
        [Parameter(
            ParameterSetName = 'AccountType',
            Mandatory = $true
        )]
        [ValidateSet('Awareness', 'Full', 'Vendor')]
        [String] $AccountType,

        [Parameter(
            ParameterSetName = 'Active',
            Mandatory = $true
        )]
        [ValidateSet($true, $false)]
        [String] $Active,

        [Parameter(
            ParameterSetName = 'Deleted',
            Mandatory = $true
        )]
        [ValidateSet($true, $false)]
        [String] $Deleted,

        [Parameter(
            ParameterSetName = 'Filter',
            Mandatory = $true
        )]
        [Array] $Filter,

        [Parameter(
            ParameterSetName = 'Vendor',
            Mandatory = $true
        )]
        [ValidateRange('Positive')]
        [UInt32] $Vendor
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'SecurityService'

        $logParameters = [ordered]@{
            'FunctionName' = $functionName
            'Level'        = $level
            'Message'      = "Executing cmdlet: $functionName"
            'Service'      = $service
            'Result'       = "Executing cmdlet: $functionName"
        }
    }

    process {
        Write-LockpathInvocationLog @logParameters

        foreach ($parameter in $PSBoundParameters.GetEnumerator()) {

            switch ($($parameter.key)) {
                'Active' {
                    $Filter = $Filter + @(@{'Field' = @{'ShortName' = "$($parameter.Key)" }; 'FilterType' = '5'; 'Value' = "$($parameter.Value)" })
                    break
                }
                'Deleted' {
                    $Filter = $Filter + @(@{'Field' = @{'ShortName' = "$($parameter.Key)" }; 'FilterType' = '5'; 'Value' = "$($parameter.Value)" })
                    break
                }
                'AccountType' {
                    switch ($($parameter.Value)) {
                        'Awareness' {
                            $AccountTypeValue = 4
                        }
                        'Full' {
                            $AccountTypeValue = 1
                        }
                        'Vendor' {
                            $AccountTypeValue = 2
                        }
                    }
                    $Filter = $Filter + @(@{'Field' = @{'ShortName' = "$($parameter.Key)" }; 'FilterType' = '5'; 'Value' = "$AccountTypeValue" })
                    break
                }
                'Vendor' {
                    $Filter = $Filter + @(@{'Field' = @{'ShortName' = "$($parameter.Key)" }; 'FilterType' = '5'; 'Value' = "$($parameter.Value)" })
                    break
                }
            }
        }

        If ($Filter.Count -gt 0) {
            $Body = [ordered]@{}
            $Body.Add('filters', $Filter)
        }

        #TODO remove next line
        $Script:LockpathConfig = [PSCustomObject]@{
            'conversionDepth' = [UInt32] 100
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Getting User Count'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'GetUserCount'
        }
        # TODO There is a bug in the GetUserCount API request (NAVEX Global ticket 01817531)
        # To compensate for this bug we need to edit the JSON in $restParameters.body so that
        # it does not use the filters key. When the bug is fixed we can delete the next line.
        $restParameters.Body = "$($Filter | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth -AsArray)"

        $shouldProcessTarget = "$($restParameters.Description) with Filter = $($restParameters.Body)"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                [string] $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.Message = 'Success: ' + $shouldProcessTarget
                try {
                    $logParameters.Result = (ConvertFrom-Json -InputObject $result) | ConvertTo-Json -Compress
                } catch {
                    $logParameters.Result = 'Unable to convert API response.'
                }
            } catch {
                $logParameters.Level = 'Error'
                $logParameters.Message = 'Failed: ' + $shouldProcessTarget
                $logParameters.Result = $_.Exception.Message
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}

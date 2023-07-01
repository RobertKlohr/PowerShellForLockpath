# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Set-LockpathUser {
    <#
    .SYNOPSIS
        Updates a user account.

    .DESCRIPTION
        Updates a user account.

        The Id attribute is mandatory. All attributes that are updated are overwritten with the new value.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Attributes
        The list of fields and values to change as an array.

        The list of attributes must include the Id field and the user Id as the value for the user being updated.

        The CommitNullProperties tag must be placed at the end of the User object.

        # FIXME update with the complete list of parameters
    .PARAMETER CommitNullProperties
        Clears all non-required field values.

        By default, the setting is false. Use the GetUser call to retrieve current values of the User object and provide UpdateUser the same User object in the request, minus whatever fields you intend to clear.

    .EXAMPLE
        Set-LockpathUser -Attributes @{'Id' = '6'; 'Groups' = @(@{'Id'= '7'}@{'Id'= '8'})}

        Allows providing a single JSON string with all attributes to change.

    .EXAMPLE
        Set-LockpathUser -Id 6 -CommitNullProperties

        Clears all non-required properties on the user account.

    .EXAMPLE
        Set-LockpathUser -Id 6 -FirstName Bob

        Allows providing one or more attributes to change.

    .INPUTS
        System.Array

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/SecurityService/UpdateUser

        The authentication account must have Read and Update Administrative Access permissions to administer users.

        For vendor contacts, the authentication account must also have the Read and Update General Access to Vendor Profiles, View and Edit Vendor Profiles workflow stage and Vendor Profiles record permission.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'This cmdlets is a wrapper for an API call that only excepts a plain text password for a password reset. The mitigating control is that the password is temporary and the platform forces the user to reset the password on first use.')]

    [CmdletBinding(
        ConfirmImpact = 'High',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    # FIXME update parameters to match set-lockpathgroup
    param(
        # AttributeAll parameter set
        [Parameter(
            ParameterSetName = 'AttributeAll',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Attributes,

        # Attribute parameter set
        [Parameter(
            ParameterSetName = 'Attribute',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('UserId')]
        [UInt32] $Id,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet(1, 2, 4)]
        [UInt32] $AccountType,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Boolean] $Active,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Boolean] $APIAccess,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [UInt32] $Department,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Mailaddress] $EmailAddress,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Fax,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $FirstName,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Int32[]] $FunctionalRoles,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Int32[]] $Groups,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $HomePhone,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Boolean] $IsLDAP,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Boolean] $IsSAML,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet(1033)]
        [UInt32] $Language,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $LastName,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [UInt32] $LDAPDirectory,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Boolean] $Locked,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [UInt32] $Manager,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $MiddleName,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $MobilePhone,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Password,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [UInt32] $SecurityConfiguration,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Int32[]] $SecurityRoles,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $Title,

        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $WorkPhone,

        # This parameter must be last in the message body
        [Parameter(
            ParameterSetName = 'Attribute',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch] $CommitNullProperties
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

        $Body = [ordered]@{}
        $Ids = @()

        foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
            if ($parameter.Value -isnot [Switch]) {
                switch ($parameter.Key) {
                    { $_ -in 'FunctionalRoles', 'Groups', 'SecurityRoles' } {
                        foreach ($value in $parameter.Value) {
                            $Ids += @{'Id' = $value }
                        }
                        $Body.Add($parameter.Key, $Ids)
                        break
                    }
                    { $_ -in 'Department', 'LDAPDirectory', 'Manager', 'SecurityConfiguration' } {
                        $Body.Add($parameter.Key, @{'Id' = $parameter.Value })
                        break
                    }
                    # { $_ -in 'AccountType', 'Active', 'APIAccess', 'Id', 'UserName', 'FirstName',
                    # 'LastName' }
                    Default {
                        $Body.Add($parameter.Key, $parameter.Value)
                    }
                }
            }
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Updating User'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'UpdateUser'
        }

        $shouldProcessTarget = "$($restParameters.Description) with Attributes = $($restParameters.Body)"

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

﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Import-LockpathFile {
    <#
    .SYNOPSIS
        Queues a job to import a file for a defined import template.

    .DESCRIPTION
        Queues a job to import a file for a defined import template.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER ComponentAlias
        Specifies the system alias of the component.

        The component alias may be found by using Get-LockpathComponentList.

    .PARAMETER ImportTemplateName
        Specifies the system name of the import template configured in the component.

    .PARAMETER FilePath
        Specifies the absolute path to the file being imported.

    .PARAMETER RunAsSystem
        Specifies if the records being imported or updated will show the created by and/or updated by attributes as
        the system. If set to false the creator and/or updated by attributes will be set to the account used to
        authenticate the API call.

        Defaults to the value in the configuration file if not supplied.

    .EXAMPLE
        Import-LockpathFile -ComponentAlias 'Vendors' -ImportTemplateName 'Load Vendor from API' -FilePath 'c:\temp\test.txt' -RunAsSystem

    .INPUTS
        IO.FileInfo, String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/ComponentService/ImportFile

        The authentication account must have Read, Create, Update, and Import/Bulk General Access permissions to
        the defined table.

        To enable the Run As System option, the authentication account must have also have Read,
        Create, and Update Administrative Access permissions to the defined table.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateLength(2, 64)]
        [ValidatePattern('^_?[A-Za-z]{1}[_A-Za-z0-9]+$')]
        [String] $ComponentAlias,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateLength(1, 128)]
        [String] $ImportTemplateName,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.IO.FileInfo] $FilePath,

        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch] $RunAsSystem = $Script:LockpathConfig.runAsSystem
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'ComponentService'

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

        $fileData = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))

        $Body = [ordered]@{
            'tableAlias'         = $ComponentAlias
            'importTemplateName' = $ImportTemplateName
            'fileName'           = $FilePath.Name
            'fileData'           = $fileData
            'runAsSystem'        = $RunAsSystem.IsPresent.ToString()
        }

        $restParameters = [ordered]@{
            'Body'        = $Body | ConvertTo-Json -Compress -Depth $Script:LockpathConfig.conversionDepth
            'Description' = 'Importing File'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'ImportFile'
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

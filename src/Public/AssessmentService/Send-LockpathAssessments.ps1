﻿# Copyright (c) Robert Klohr. All rights reserved.
# Licensed under the MIT License.

function Send-LockpathAssessments {
    <#
    .SYNOPSIS
        Issue an assessment.

    .DESCRIPTION
        Issue an assessment.

        Internal assessments can be issued with either immediate, onetime or recurring frequency.

        Vendor assessments can be issued with either immediate or recurring frequency.

        The Git repo for this module can be found here: https://git.io/powershellforlockpath

    .PARAMETER Attributes
        The list of fields and values to configure the assessment.

    .EXAMPLE
        Send-LockpathAssessments

    .INPUTS
        String

    .OUTPUTS
        String

    .NOTES
        Native API Request: https://[InstanceName]:[InstancePort]/AssessmentService/IssueAssessment

        The authentication account must have Read and Update General Access permissions for the specific component, record and field.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    <# TODO The current (5.7) API guide only has XML examples for the request body and none of the body attribute are defined.  Until this is documented this function is not exported in the module.
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This cmdlets is a wrapper for an API call that uses a plural noun.')]

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]

    [OutputType([System.String])]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String] $AssessmentRequest
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'AssessmentService'

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

        $restParameters = [ordered]@{
            'Body'        = $AssessmentRequest
            'Description' = 'Issuing Assessment'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'IssueAssessment'
        }

        $shouldProcessTarget = $restParameters.Description

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

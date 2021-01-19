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

        The authentication account must have Read and Update General Access permissions for the specific component,
        record and field.

    .LINK
        https://git.io/powershellforlockpathhelp
    #>

    <# TODO The current (5.7) API guide only has XML examples for the request body and none of the body attribute are defined.  Until this is documented this function is not exported in the module.
    #>

    [CmdletBinding(
        ConfirmImpact = 'Medium',
        PositionalBinding = $false,
        SupportsShouldProcess = $true)]
    [OutputType('System.String')]

    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String] $AssessmentRequest
    )

    begin {
        $level = 'Information'
        $functionName = ($PSCmdlet.CommandRuntime.ToString())
        $service = 'AssessmentService'
    }

    process {
        if ($Script:LockpathConfig.loggingLevel -eq 'Debug') {
            Write-LockpathInvocationLog -Confirm:$false -WhatIf:$false -FunctionName $functionName -Level $level -Service $service
        }

        $restParameters = [ordered]@{
            'Body'        = $AssessmentRequest
            'Description' = 'Issuing Assessment'
            'Method'      = 'POST'
            'Service'     = $service
            'UriFragment' = 'IssueAssessment'
        }

        $logParameters = [ordered]@{
            'Confirm'      = $false
            'WhatIf'       = $false
            'Message'      = $message
            'FunctionName' = $functionName
            'Level'        = $level
            'Service'      = $service
        }

        $shouldProcessTarget = "Id=$AssessmentRequest"

        if ($PSCmdlet.ShouldProcess($shouldProcessTarget)) {
            try {
                $result = Invoke-LockpathRestMethod @restParameters
                $logParameters.message = 'success'
            } catch {
                $result = $_.ErrorDetails.Message.Split('"')[3]
                $logParameters.message = 'failed'
                $logParameters.level = 'Warning'
            } finally {
                Write-LockpathLog @logParameters
            }
            return $result
        }
    }

    end {
    }
}

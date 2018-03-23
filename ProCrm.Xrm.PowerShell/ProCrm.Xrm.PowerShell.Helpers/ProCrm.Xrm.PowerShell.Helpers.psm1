function Invoke-XrmWorkflow () {
    
    param (
        
        [string]$viewName,
        [string]$WorkflowName
    )

    Write-Output "Starting workflows ..."
    Write-Output ""
    
    $crmrecords  = Get-CrmRecordsByViewName -ViewName $viewName

    Write-Output "Found $crmrecords.Count to execute the workflow ..."

    foreach ($crmrecord in $crmrecords.CrmRecords) 
    {   
        Invoke-CrmRecordWorkflow -CrmRecord $crmrecord -WorkflowName $WorkflowName
    }
    
    Write-Output ""
    Write-Output "... workflow execution finished."
}
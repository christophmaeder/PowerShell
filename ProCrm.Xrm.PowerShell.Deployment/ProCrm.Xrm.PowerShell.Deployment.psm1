    function New-XrmPublisherAndDefaultSolution() 
{    
    param (   
        [string]$PublisherName,
        [string]$PublisherLogicalName,
        [string]$PublisherPrefix,
        [string]$SolutionName,
        [string]$SolutionLogicalName
    )

    Write-Output "Creating solution and publisher ..."
    Write-Output ""

    # CREATE Publisher
    $publishers = Get-CrmRecords -EntityLogicalName publisher -FilterAttribute uniquename -FilterOperator eq -FilterValue $PublisherLogicalName
    
    if($publishers.Count -eq 0)
    {
        $publisherid = New-CrmRecord -EntityLogicalName publisher -Fields @{"uniquename"=$PublisherLogicalName;"friendlyname"=$PublisherName;"customizationprefix"=$PublisherPrefix}
    }
    else
    {
        $publisherid = $publishers.CrmRecords[0].publisherid    
    }

    Write-Output "Publisher with id = $publisherid found or created ..."

    # CREATE SOLUTION
    $publisherref = New-CrmEntityReference -EntityLogicalName publisher -Id $publisherid

    $solutionid = New-CrmRecord -EntityLogicalName solution -Fields @{"uniquename"=$SolutionLogicalName;"friendlyname"=$SolutionName;"publisherid"=$publisherref;"version"="1.0.0.0"}

    Write-Output ""
    Write-Output "... solution created ($solutionid)."

    return $solutionid
}

Function Invoke-XrmSolutionVersionIncremention()
{
    params(
        [string]$SolutionName
    )

    $solutions = Get-CrmRecords -EntityLogicalName solution -FilterAttribute uniquename -FilterOperator eq -FilterValue $SolutionName -Fields uniquename,version,ismanaged
        
    $solution = $solutions.CrmRecords[0]
    $currentVersion = $solution.version
    
    $positionIndexOfLastDot = $currentVersion.LastIndexOf('.')
    $currentVersionLastNumber = [convert]::ToInt32($currentVersion.Substring($positionIndexOfLastDot+1,$currentVersion.Length-$positionIndexOfLastDot-1))
    $solution.version = ($solution.version.SubString(0,$positionIndexOfLastDot+1))+($currentVersionLastNumber + 1).ToString()
    
    Set-CrmRecord -CrmRecord $solution
    
    Write-Output Version number of solution $solutionname updated to $solution.version
}
Function Import-XrmSolution(){

    param (
        
        [string]$solutionPath
    )

    Try{
        Write-Output "Importing solution ..."
        Write-Output ""

        Import-CrmSolution -SolutionFilePath $solutionPath -ActivatePlugIns $true -MaxWaitTimeInSeconds 12000

        Write-Output ""
        Write-Output "... solution imported."

    }Catch
    {
        Write-Output "Error $_.Exception.Message"
        $_.Exception.InnerException.Message
    }
}

Function Export-XrmSolution(){

    param (
        
        [string]$solutionName,
        [string]$solutionPath
    )

    Try{
        Write-Output "Exporting solution ..."
        Write-Output ""

        Export-CrmSolution -SolutionName:$solutionname -SolutionZipFileName:$solutionname'_Managed.zip' -SolutionFilePath:$solutionPath -Managed:$true
        Invoke-XrmSolutionVersionIncremention -solutionname $solutionname

        Write-Output ""
        Write-Output "... solution exported."

    }Catch
    {
        Write-Output "Error $_.Exception.Message"
        $_.Exception.InnerException.Message
    }
}

Function Remove-XrmSolution(){

    param (
        
        [string]$solutionName
    )
    
    Write-Output "Deleting solution ..."
    Write-Output ""
    
    $solutions = Get-CrmRecords -EntityLogicalName solution -FilterAttribute uniquename -FilterOperator eq -FilterValue $solutionName -Fields uniquename,version,ismanaged
    $solution = $solutions.CrmRecords[0]

    Remove-CrmRecord -CrmRecord $solution
    
    Write-Output ""
    Write-Output "... solution deleted."
}
function CreatePublisherAndDefaultSolution() 
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
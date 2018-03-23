
# In this library:
# 
# GetAllSolutionsDataToCsv -CsvPath "C:\temp\solutions.csv"

# IMPORT MODULE
Import-Module Microsoft.Xrm.Data.Powershell

function ExportAllSolutionDataToCsv()
{
    param(
        [string]$CsvPath
    )

    Write-Host "Getting solutions and creating CSV file ..."
    Write-Host ""

    $solutions = Get-CrmRecords -EntityLogicalName solution -Fields uniquename,friendlyname,ismanaged
    
    Add-Content -Path $CsvPath -Value "DisyplayName;UniqueName;IsManaged"

    foreach($solution in $solutions.CrmRecords)
    {
        $uname = $solution.uniquename
        $disname = $solution.friendlyname
        $ismanaged = $solution.ismanaged.ToString()

        Write-Host "$disname;$uname;$ismanaged"
        Add-Content -Path $CsvPath  -Value "$disname;$uname;$ismanaged"
    }

    Write-Host ""
    Write-Host "Finished getting and exporting solution data."
}
function CreatePublisherAndDefaultSolution() 
{    
    param (   
        [string]$publishername,
        [string]$publisherlogicalname,
        [string]$publisherprefix,
        [string]$solutionname,
        [string]$solutionlogicalname
    )

    Write-Output "Creating solution and publisher ..."
    Write-Output ""

    # CREATE Publisher
    $publishers = Get-CrmRecords -EntityLogicalName publisher -FilterAttribute uniquename -FilterOperator eq -FilterValue $publisherlogicalname
    
    if($publishers.Count -eq 0)
    {
        $publisherid = New-CrmRecord -EntityLogicalName publisher -Fields @{"uniquename"=$publisherlogicalname;"friendlyname"=$publishername;"customizationprefix"=$publisherprefix}
    }
    else
    {
        $publisherid = $publishers.CrmRecords[0].publisherid    
    }

    Write-Output "Publisher with id = $publisherid found or created ..."

    # CREATE SOLUTION
    $publisherref = New-CrmEntityReference -EntityLogicalName publisher -Id $publisherid

    $solutionid = New-CrmRecord -EntityLogicalName solution -Fields @{"uniquename"=$solutionlogicalname;"friendlyname"=$solutionname;"publisherid"=$publisherref;"version"="1.0.0.0"}

    Write-Output ""
    Write-Output "... solution created ($solutionid)."
}

function CreateNewAutonumberAttribute () {
    
    param (   
        [string]$AttributeName,
        [string]$AttributeDisplayname,
        [string]$EntitySchemaname,
        [string]$AutoNumberFormat
    )

    Write-Output "Creating autonumber attribute $attributename ..."
    Write-Output ""

    $autonumattribute = New-Object Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata
    $autonumattribute.SchemaName = $attributename
    $autonumattribute.LogicalName = $attributename
    $autonumattribute.DisplayName = New-Object Microsoft.Xrm.Sdk.Label($attributedisplayname,1033)
    $autonumattribute.Format = [Microsoft.Xrm.Sdk.Metadata.StringFormat]::Text
    $autonumattribute.MaxLength = 100
    $autonumattribute.AutoNumberFormat = "{SEQNUM:6}"

    $request = New-Object Microsoft.Xrm.Sdk.Messages.CreateAttributeRequest
    $request.Attribute = $autonumattribute
    $request.EntityName = $entityschemaname

    $conn.Execute($request)

    Write-Output ""
    Write-Output "... autonumber attribute $attributename created."
}
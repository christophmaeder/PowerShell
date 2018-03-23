function Export-AllCrmSolutionDataToCsv()
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

function New-CrmAutonumberAttribute () {
    
    param (   
        [string]$AttributeName,
        [string]$AttributeDisplayname,
        [string]$EntitySchemaname,
        [string]$AutoNumberFormat
    )

    Write-Output "Creating autonumber attribute $AttributeName ..."
    Write-Output ""

    $autonumattribute = New-Object Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata
    $autonumattribute.SchemaName = $AttributeName
    $autonumattribute.LogicalName = $AttributeName
    $autonumattribute.DisplayName = New-Object Microsoft.Xrm.Sdk.Label($attributedisplayname,1033)
    $autonumattribute.Format = [Microsoft.Xrm.Sdk.Metadata.StringFormat]::Text
    $autonumattribute.MaxLength = 100
    $autonumattribute.AutoNumberFormat = $AutoNumberFormat

    $request = New-Object Microsoft.Xrm.Sdk.Messages.CreateAttributeRequest
    $request.Attribute = $autonumattribute
    $request.EntityName = $EntitySchemaname

    $response = $conn.Execute($request)

    Write-Output ""
    Write-Output "... autonumber attribute $AttributeName created."
    
    return $response
}

function New-CrmEntity() {

    param (   
        [string]$EntityName,
        [string]$EntitySchemaName,
        [string]$EntityPrefix
    )
    
    Write-Output "Creating new entity $EntityName ..."
    Write-Output ""

    $newentity = New-Object Microsoft.Xrm.Sdk.Metadata.EntityMetadata
    $newentity.SchemaName = $EntityPrefix+"_"+$EntitySchemaName
    $newentity.DisplayName = New-Object Microsoft.Xrm.Sdk.Label($EntityName, 1033)
    $newentity.DisplayCollectionName = New-Object Microsoft.Xrm.Sdk.Label($($EntityName + 's'),1033)
    $newentity.OwnershipType = [Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned
    $newentity.IsActivity = $false

    $primattribute = New-Object Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata
    $primattribute.SchemaName = $EntityPrefix+"_name"
    $primattribute.DisplayName = New-Object Microsoft.Xrm.Sdk.Label("Name",1033)
    $primattribute.Format = [Microsoft.Xrm.Sdk.Metadata.StringFormat]::Text
    $primattribute.MaxLength = 100

    $request = New-Object Microsoft.Xrm.Sdk.Messages.CreateEntityRequest
    $request.Entity = $newentity
    $request.PrimaryAttribute = $primattribute

    $response = $conn.Execute($request)
   
    Write-Output ""
    Write-Output "... entity $EntityName created."

    return $response
}

function Remove-CrmEntity () {
    
    param (
        
        [string]$EntityLogicalName
    )
    
    Write-Output "Deleting entity ..."
    Write-Output ""
    
    # TODO
    
    Write-Output ""
    Write-Output "... entity deleted."
}
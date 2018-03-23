Function Add-XrmUserToSecurityRole(){
    
    param (
        
        [string]$loginname,
        [string]$rolename
    )

    Write-Output "Adding security role $rolename to user $loginname ..."
    Write-Output ""

    # Get users and roles
    $systemusers = Get-CrmRecords -EntityLogicalName SystemUser -FilterAttribute domainname -FilterOperator eq -FilterValue $loginname
    $securityroles = Get-CrmRecords -EntityLogicalName role -FilterAttribute name -FilterOperator eq -FilterValue $rolename

    # Get the recordIDs
    $systemuserid = $systemusers.CrmRecords[0].systemuserid
    $securityroleid = $securityroles.CrmRecords[0].roleid

    # Add the role
    Add-CrmSecurityRoleToUser -UserId $systemuserid -SecurityRoleId $securityroleid 
    # --> works only, if you have only one org. if there are orgs, then it finds more than one role
    
    Write-Output ""
    Write-Output "... security role added."
}

Function Get-XrmRecordsCount()
{
    param (
        $EntityNames
    )

    Write-Output "Counting records..."
    Write-Output ""

    foreach($entityName in $entityNames)
    {
        $count = Get-CrmRecordsCount -EntityLogicalName $entityName
        Write-Output "$count ${entityName}s found."
    }

    Write-Output ""
    Write-Output "... counting finished."
}
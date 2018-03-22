
# In this library:
# 
# GetAllSolutionsDataToCsv -CsvPath "C:\temp\solutions.csv"

function GetAllSolutionsDataToCsv()
{
    param(
        [string]$CsvPath
    )

    # IMPORT MODULE
    Import-Module Microsoft.Xrm.Data.Powershell

    # CREATE A CRM CONNECTION
    Connect-CrmOnlineDiscovery -InteractiveMode

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
}

# IMPORT MODULES
Import-Module Microsoft.Xrm.Data.Powershell

function InitCrmConnectionInteractive() 
{ 
    # CREATE A CRM CONNECTION
    Connect-CrmOnlineDiscovery -InteractiveMode
}

function InitCrmConnection()
{ 
    param(
        [System.Management.Automation.PSCredential]$CrmCredentials   ,
        [string]$CrmServerUrl     
    )

    # CREATE A CRM CONNECTION
    Connect-CrmOnline -Credential $CrmCredentials -ServerUrl $CrmServerUrl 
}

function GetPsCredentials()
{
    param(
        [string]$Username,
        [securestring]$Password      
    )

    return New-Object System.Management.Automation.PSCredential ($Username, $Password)
}
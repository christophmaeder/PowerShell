function Invoke-CrmConnectionInteractive() 
{ 
    # CREATE A CRM CONNECTION
    Connect-CrmOnlineDiscovery -InteractiveMode
}

function Invoke-CrmConnection()
{ 
    param(
        [System.Management.Automation.PSCredential]$CrmCredentials   ,
        [string]$CrmServerUrl     
    )

    # CREATE A CRM CONNECTION
    Connect-CrmOnline -Credential $CrmCredentials -ServerUrl $CrmServerUrl 
}

function Get-Credentials()
{
    param(
        [string]$Username,
        [securestring]$Password      
    )

    return New-Object System.Management.Automation.PSCredential ($Username, $Password)
}
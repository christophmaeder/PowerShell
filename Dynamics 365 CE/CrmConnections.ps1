
##### BEGIN Creating a connection to Dynaics 365 CE  #####

    # IMPORT MODULES
    Import-Module Microsoft.Xrm.OnlineManagementAPI
    Import-Module Microsoft.Xrm.Data.Powershell

    # IMPORT FUNCTION FILES
    #. "C:\Users\Admin\Documents\Visual Studio 2017\Code Snippets\PowerShell\Helpers\CrmConnection.ps1"

    # INIT CONNECTION VARIABLES                
    $ApiUrl = "https://admin.services.crm4.dynamics.com"
    $CrmServerUrl = "https://xy.crm4.dynamics.com"

    # CREATE CREDENTIALS
    $Username = ""
    $Password = Read-host "Password:" -AsSecureString 
    $Cred = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    
    # CREATE A CRM CONNECTION
    Connect-CrmOnline -Credential $Cred -ServerUrl $CrmServerUrl # Used by "Microsoft.Xrm.Data.Powershell" cmdlets
    
##### END Creating a connection to Dynaics 365 CE #####
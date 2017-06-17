function Check-AD {
    <#  
    .Synopsis  
        Checking ActiveDirectory module in system. Else - exit. 
    #>
    
    Try {
        Import-Module ActiveDirectory -ErrorAction Stop
        }
    Catch {
        Write-Host -ForegroundColor Yellow "No powershell module for Active Directory managment installed. Please install AD LDS managment module in features section of your server."
        Write-Host -ForegroundColor Red "Script execution stopped."
        }
    Finally {
    
        } 
}
Check-AD
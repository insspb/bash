﻿function Check-Admin {
    <#  
    .Synopsis  
        Checking script running as administrator. Else - exit.
    #>

    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
        Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
        Break
    }
}
Check-Admin
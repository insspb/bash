function List-Inactive {
    <#  
    .Synopsis  
        Get all inactive users from current AD with last login since input days. Default for 30 days and only currently enabled users.
    #>
    Param(
        [int]$InactiveDays = 30,
        [bool]$Enabled = $true
    )
    $time = Get-Date (Get-Date).Adddays(-($InactiveDays))
    $UsersList = Get-ADUser -Filter 'lastLogon -lt $time -and Enabled -eq $Enabled'
    return $UsersList
}
List-Inactive
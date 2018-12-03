function List-NoExpires {
    <#  
    .Synopsis  
        Get all users from current AD with password never expires flag.
    #>
    $UsersList = Get-ADUser -Filter * -Properties Name,PasswordNeverExpires | where { $_.passwordNeverExpires -eq "true" }
    return $UsersList
}
List-NoExpires
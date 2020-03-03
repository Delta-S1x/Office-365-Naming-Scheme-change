Connect-AzureAD
$UserCredential = Get-Credential

#Select Users
$users = Get-AzureADUser -All:$True |Out-GridView -OutputMode Multiple

# Create an Exchange session
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# Import that session
Import-PSSession $Session -DisableNameChecking

forEach ($user in $users) {
    $oldmail = $user.UserPrincipalName
    #SET YOUR NEW NAMING SCHEME HERE
    $newmail = ($user.GivenName+ "." + $user.Surname + "@WHATEVERCOMPANY.COM").ToLower()
    $newmail
    #Changes username to the new naming scheme
    Set-AzureADUser -ObjectId $user.UserPrincipalName -UserPrincipalName $newmail
    #adds old email as an alias
    Set-Mailbox -Identity $user.UserPrincipalName -EmailAddresses @{add=$oldmail}
}

#Closes the PsSession
Get-PSSession | Remove-PSSession

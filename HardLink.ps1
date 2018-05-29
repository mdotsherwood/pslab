#Connect to Exchange Online via Powershell and then...

#get AD user object, assign to $aduser variable
$aduser = Get-ADUser sharedmbtest

#convert AD object guid to immutableid (guid -> byte array -> base64 string), assign to $immutableid variable
$immutableid = [system.convert]::ToBase64String($aduser.objectGUID.toByteArray())

#set immutableID of shared mailbox to immutableid derived from AD object guid
Set-Mailbox -Identity sharedmbtest@email.com -ImmutableID $immutableid

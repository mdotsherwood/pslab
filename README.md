# pslab

Just a collection of test PowerShell scripts. Quickly written proof-of-concepts. 

**!!! Not for production environments !!!** :)

## CreateUsers.ps1 - Create Active Directory users
Usage: `.\CreateUsers.ps1 -file [filename.csv]`

Description: Reads CSV `[filename.csv]` and creates Active Directory users based on information provided. If `-file` switch is not used, filename defaults to `users.csv`.

CSV headers: `fname,lname,name,username,password,email,dept,atm,atmpassword,ext,pin`

## RestartComputers.ps1 - Restarts computers in specified Active Directory Organization Unit (OU)
Usage: `.\RestartComputers.ps1 -OU [OU string]`

This is a work in progress. Currently returns a list of computers in a specified OU that have the `department` attribute set to `RESTART`.

Example: `.\RestartComputers.ps1 -OU "CN=Computers,DC=testenv,DC=int"`

## HardLink.ps1 - Hard-link Active Directory and O365 Exchange object
Uses `GUID` of Active Directory object to hard-link on-premise ActiveDirectory object to cloud-created O365 Exchange object.

Does so by setting the `ImmutableID` of O365 Exchange object to unique identifier derived from Active Directory user `GUID`.

This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise Active Directory object.

Please note that both objects' `UserPrincipalName` need to match as well.

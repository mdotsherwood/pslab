# pslab

Just a collection of test PowerShell scripts. Quickly written proof-of-concepts. 

**Not for production environments.** :)

## CreateUsers.ps1 - Create ActiveDirectory users
Usage: `.\CreateUsers.ps1 -file [filename.csv]`

Description: Reads CSV `[filename.csv]` and creates ActiveDirectory users based on information provided. If `-file` switch is not used, filename defaults to `users.csv`.

CSV headers: `fname,lname,name,username,password,email,dept,atm,atmpassword,ext,pin`

## HardLink.ps1 - Hard-link ActiveDirectory and O365 Exchange object
Uses `GUID` of ActiveDirectory object to hard-link on-premise ActiveDirectory object to cloud-created O365 Exchange object.

Does so by setting the `ImmutableID` of O365 Exchange object to unique identifier derived from ActiveDirectory user `GUID`.

This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise ActiveDirectory object.

Please note that both objects' `UserPrincipalName` need to match as well.

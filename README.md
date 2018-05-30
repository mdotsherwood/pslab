# pslab

Just a collection of test PowerShell scripts. Quickly written proof-of-concepts.

Things To Do Across The Board: logging, error handling, data validation, documentation, testing, everything.

**!!! Not for production environments !!!** :)

## CreateUsers.ps1 - Create Active Directory (AD) users
Usage: `.\CreateUsers.ps1 -file [filename.csv]`

Description: Reads CSV `[filename.csv]` and creates AD users based on information provided. If `-file` switch is not used, filename defaults to `users.csv`.

CSV headers: `fname,lname,name,username,password,email,dept,atm,atmpassword,ext,pin`

## RestartComputers.ps1 - Restarts computers in specified AD Organizational Unit (OU)
Usage: `.\RestartComputers.ps1 -OU [OU string]`

This is a work in progress. Currently returns a list of computers in a specified OU that have the `department` attribute set to `RESTART`.

Example: `.\RestartComputers.ps1 -OU "OU=Computers,OU=Company Name,DC=testenv,DC=int"`

## HardLink.ps1 - Hard-link AD and O365 Exchange object
Uses `GUID` of AD object to hard-link on-premise AD object to cloud-created O365 Exchange object.

Does so by setting the `ImmutableID` of O365 Exchange object to unique identifier derived from AD user `GUID`.

This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise AD object.

Please note that both objects' `UserPrincipalName` need to match as well.

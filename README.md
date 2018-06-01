# pslab

Just a collection of test PowerShell scripts. Quickly written proof-of-concepts.

All code written with a particular environment in mind so you will need to make modifications in order for these scripts to work in your environment.

Things To Do Across The Board: logging, error handling, data validation, documentation, testing, everything.

**!!! Not for production environments !!!** :)

## CreateUsers.ps1 - Create Active Directory (AD) users
Usage: `.\CreateUsers.ps1 -file [filename.csv]`

Description: Reads CSV `[filename.csv]` and creates AD users based on information provided. If `-file` switch is not used, filename defaults to `users.csv`. Adds user to appropriate OU, Security Groups and Distribution Groups based on department (IVAN, PR, CS). Also pre-fills following attributes: name, email, department, title, description, home (off), pager (e3), home directory, logon script. Sets password.

CSV header requirements: `fname,lname,name,username,password,email,dept`

Example: `.\CreateUsers.ps1 -file "C:\new_users_05202018.csv"`

## RestartComputers.ps1 - Restarts computers in specified AD Organizational Unit (OU)
Usage: `.\RestartComputers.ps1 [-OU <string>="CN=Computers,DC=testenv,DC=int"] [-Attribute [LDAP <string>="department"] [-Match <string>="RESTART"`

Description: Retrieves a list of computers that are in a specified `OU`. Computers are only added to the list if the `Attribute` specified is equal to the `Match` string specified. Script then issues a restart command to each computer individually. Test with caution.

Example: `.\RestartComputers.ps1 -OU "OU=Computers,OU=Company Name,DC=testenv,DC=int" -Attribute "department" -Match "RESTART"`

## HardLink.ps1 - Hard-link AD and O365 Exchange object
Uses `GUID` of AD object to hard-link on-premise AD object to cloud-created O365 Exchange object.

Does so by setting the `ImmutableID` of O365 Exchange object to unique identifier derived from AD user `GUID`.

This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise AD object.

Please note that both objects' `UserPrincipalName` need to match as well.

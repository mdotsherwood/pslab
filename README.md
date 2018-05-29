# pslab

Just a collection of test PowerShell scripts. Quickly written proof-of-concepts. 

**Not for production environments.** :)

## CreateUsers.ps1 - Create ActiveDirectory users
Use: `.\CreateUsers.ps1 -file [filename.csv]`

Reads CSV [filename.csv] and creates ActiveDirectory users based on information provided. If `-file` switch is not used, filename defaults to `users.csv`.

CSV headers: fname,lname,name,username,password,email,dept,atm,atmpassword,ext,pin

## HardLink.ps1 - Hard-link ActiveDirectory and O365 Exchange object
Uses GUID of ActiveDirectory object to hard-link on-premise AD object to cloud-created O365 Exchange object. This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise ActiveDirectory object.

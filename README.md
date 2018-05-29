# pslab

Just a collection of test PowerShell scripts. Not for production environments. :)

## CreateUsers.ps1 - Create AD users.
Reads CSV file named users.csv placed in same folder as CreatUsers script.

CSV headers: fname,lname,name,username,password,email,dept,atm,atmpassword,ext,pin

## HardLink.ps1 - Hard-link ActiveDirectory and O365 Exchange object
Uses GUID of ActiveDirectory object to hard-link on-premise AD object to cloud-created O365 Exchange object. This allows for an object that has been previously created in the O365/Exchange cloud to be subsequently managed by manipulating the hard-linked, on-premise ActiveDirectory object.

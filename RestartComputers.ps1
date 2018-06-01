#Define parameters and default values
param([string] $OU = "CN=Computers,DC=testenv,DC=int", [string] $attribute="department", [string] $match="RESTART")

$filename = 'C:\Reboots.log'
#Print informational messages
"Starting reboot script..." | Out-File -FilePath $filename -append
$date = Get-Date -format g
"Date/Time: $($date)" | Out-File -FilePath $filename -append
"Retrieving list of computers..." | Out-File -FilePath $filename -append

#Get a list of computers based on OU membership and attribute value. Print error message and terminate if unsuccessful.
try{
	$computers = Get-ADComputer -LDAPFilter "($attribute=$match)" -SearchBase $OU -ErrorAction Stop
}
catch{
	$ErrorMessage = $_.Exception.Message
	"An error has occurred while retrieving a list of computers." | Out-File -FilePath $filename -append
	"Error Message: $($ErrorMessage)" | Out-File -FilePath $filename -append
	Break
}

#Iterate through computers and restart each. If restart command is unable to be issued, print error and move along.
foreach($computer in $computers){
	"==========" | Out-File -FilePath $filename -append
	"Restarting $($computer.name)..." | Out-File -FilePath $filename -append
	try{
		Restart-Computer -ComputerName $computer.name -ErrorAction Stop
		"Restart command issued successfully to $($computer.name)." | Out-File -FilePath $filename -append
	}
	catch{
		$ErrorMessage = $_.Exception.Message
		"Failed to restart $($computer.name)." | Out-File -FilePath $filename -append
		"Error: $($ErrorMessage)" | Out-File -FilePath $filename -append
	}
}

#Print informational messages
$date = Get-Date -Format g
"==========" | Out-File -FilePath $filename -append
"Done." | Out-File -FilePath $filename -append
"Date/Time: $($date)" | Out-File -FilePath $filename -append
"==========" | Out-File -FilePath $filename -append

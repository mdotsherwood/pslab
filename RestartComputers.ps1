#Define parameters and default values
param([string] $OU = "CN=Computers,DC=testenv,DC=int", [string] $attribute="department", [string] $match="RESTART")

#Print informational messages
Write-Host "Starting reboot script..."
$date = Get-Date -format g
Write-Host "Date/Time: $($date)"
Write-Host "Retrieving list of computers..."

#Get a list of computers based on OU membership and attribute value. Print error message and terminate if unsuccessful.
try{
	$computers = Get-ADComputer -LDAPFilter "($attribute=$match)" -SearchBase $OU -ErrorAction Stop
}
catch{
	$ErrorMessage = $_.Exception.Message
	Write-Host "An error has occurred while retrieving a list of computers."
	Write-Host "Error Message: $($ErrorMessage)"
	Break
}

#Iterate through computers and restart each. If restart command is unable to be issued, print error and move along.
foreach($computer in $computers){
	Write-Host "=========="
	Write-Host "Restarting $($computer.name)..."
	try{
		Restart-Computer -ComputerName $computer.name -ErrorAction Stop
		Write-Host "Restart command issued successfully to $($computer.name)."
	}
	catch{
		$ErrorMessage = $_.Exception.Message
		Write-Host "Failed to restart $($computer.name)."
		Write-Host "Error: $($ErrorMessage)"
	}
}

#Print informational messages
$date = Get-Date -Format g
Write-Host "=========="
Write-Host "Done."
Write-Host "Date/Time: $($date)"
Write-Host "=========="

#Define parameters and default values
param([string] $OU = "CN=Computers,DC=testenv,DC=int", [string] $attribute="department", [string] $match="RESTART",[switch]$v,[string]$filename='C:\Reboots.log')

if($v){
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
}
else{
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
}

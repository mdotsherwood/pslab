param([string] $OU = "CN=Computers,DC=tesftenv,DC=int")

$attribute="department"
$attrstrmatch="RESTART"

Write-Host "Starting reboot script..."
$date = Get-Date -format g
Write-Host "Date/Time: $($date)"
Write-Host "Retrieving list of computers..."
try{
	$computers = Get-ADComputer -LDAPFilter "($attribute=$attrstrmatch)" -SearchBase $OU -ErrorAction Stop
}
catch{
	$ErrorMessage = $_.Exception.Message
	Write-Host "An error has occurred while retrieving a list of computers."
	Write-Host "Error Message: $($ErrorMessage)"
	Break
}

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

  # OLD SCHOOL WAY
  #invoke-command -scriptblock {
  #  shutdown /m $computer.name /r /f /t 5
  #} -ArgumentList $computer.name
}
$date = Get-Date -Format g
Write-Host "=========="
Write-Host "Done."
Write-Host "Date/Time: $($date)"
Write-Host "=========="

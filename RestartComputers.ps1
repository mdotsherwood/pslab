param([string] $OU = "CN=Computers,DC=testenv,DC=int")

$computers = Get-ADComputer -LDAPFilter "(department=RESTART)" -SearchBase $OU

Write-Host "Computers to restart: "
foreach($computer in $computers){

  invoke-command -scriptblock {
  		shutdown /m $computer.name /r /f /t 5
  	} -ArgumentList $computer.name

}

# test branching

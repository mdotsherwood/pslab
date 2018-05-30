param([string] $OU = "CN=Computers,DC=testenv,DC=int")

$computers = Get-ADComputer -LDAPFilter "(department=RESTART)" -SearchBase $OU

Write-Host "Computers to restart: "
Write-Host $computers.name

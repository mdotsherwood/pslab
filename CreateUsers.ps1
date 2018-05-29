$users = import-csv users.csv
$exclude = @()
$path = "OU=Users,OU=testllc,DC=testenv,DC=int"
$description = ""
$logonscript = ""

Write-Host "Creating users...."

foreach($user in $users){

	Write-Host "Creating user for: $($user.name)"
	
	if(dsquery user -samid $user.username){
	
		Write-Host "Skipping account creation for: $($user.name). Username $($user.username) already exists."
		
		$exclude += $user
		
	}
	else {
	
		Write-Host "Using username: $($user.username)..."
		
		$HomeDrive = "X"
		$HomeDirectory = "\\datavault01\users\users\$($user.username)"
		
		if($user.dept -eq "IVAN"){
			$path = "OU=IVAN,OU=Users,OU=testllc,DC=testenv,DC=int"
			$description = "Verifications Researcher"
			$dept = "Verifications"
			$logonscript = "IVAN.bat"
		}
		elseif($user.dept -eq "PR"){
			$path = "OU=PR,OU=Users,OU=testllc,DC=testenv,DC=int"
			$description = "Public Records Researcher"
			$dept = "Public Records"
			$logonscript = "PR.BAT"
		}
		elseif($user.dept -eq "CS"){
			$path = "OU=CS,OU=Users,OU=testllc,DC=testenv,DC=int"
			$description = "Client Service Representative"
			$dept = "Client Services"
			$logonscript = "CS.BAT"
		}
		else{
			$path = "OU=Users,OU=testllc,DC=testenv,DC=int"
		}
			
		new-aduser -samaccountname $user.username -userprincipalname $user.email -displayname $user.name -name $user.name -givenname $user.fname -surname $user.lname -emailaddress $user.email -homephone "off" -Path $path -AccountPassword (ConvertTo-SecureString -AsPlainText $user.password -Force) -Enabled 1 -description $description -title $description -homedrive $HomeDrive -homedirectory $homedirectory -Department $dept -ScriptPath $logonscript -OtherAttributes @{'pager'="e3"}
	
	}
	
}

Write-Host "Adding users to groups..."

foreach($user in $users){
	if($exclude.contains($user)){
	
		Write-Host "Excluding $($user.username)..."
		
	}
	else {
		
		if($user.dept -eq "IVAN"){
			$tempun = "ivanuser"
		}
		elseif($user.dept -eq "PR"){
			$tempun = "pruser"
		}
		elseif($user.dept -eq "CS"){
			$tempun = "csuser"
		}
		else {
			$tempun = "tempuser"
		}
		
		Write-Host "Adding $($user.username) to the same group as $($tempun)..."
		
		(Get-AdUser -identity $tempun -properties memberof).memberof | Add-ADGroupMember -Members $user.username
		
	}

}
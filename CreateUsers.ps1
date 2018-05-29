# Commenting and documentation

$users = import-csv users.csv
$exclude = @()
$path = "OU=Users Active,OU=Accurate Background,DC=accuratebackground,DC=int"
$description = ""
$logonscript = ""

Write-Host "Creating users..."

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
			$path = "OU=Ivan Users,OU=Verifications,OU=Accurate Background,DC=accuratebackground,DC=int"
			$description = "Verifications Researcher"
			$dept = "Verifications"
			$logonscript = "DFSVERIFICATIONSLOGIN.bat"
		}
		elseif($user.dept -eq "PR"){
			$path = "OU=Hirease Users,OU=Hirease,OU=Accurate Background,DC=accuratebackground,DC=int"
			$description = "Public Records Researcher"
			$dept = "Public Records"
			$logonscript = "DFSPUBLICRECORDSLOGIN.bat"
		}
		elseif($user.dept -eq "CS"){
			$path = "OU=Client Services Users,OU=Client Services,OU=Accurate Background,DC=accuratebackground,DC=int"
			$description = "Client Service Representative"
			$dept = "Client Services"
			$logonscript = "DFSCLIENTSERVICESLOGIN.bat"
		}
		else{
			$path = "OU=Users Active,OU=Accurate Background,DC=accuratebackground,DC=int"
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

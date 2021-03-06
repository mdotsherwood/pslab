# Please add commenting and documentation!

param([string] $file = "users.csv")

#import CSV containing list of users to create
$users = import-csv $file

Write-Host "Reading template configuration..."
$TemplateFile = ".\DeptTemplate.xml"
[xml]$DeptTemplates = Get-Content $TemplateFile

#Load department templates
Write-Host "Creating template objects from template configuration file...."
$IVAN_T = Select-XML -XML $DeptTemplates -Xpath "//Department[@code = 'IVAN']"
$CS_T = Select-XML -XML $DeptTemplates -Xpath "//Department[@code = 'CS']"
$PR_T = Select-XML -XML $DeptTemplates -Xpath "//Department[@code = 'PR']"

#init vars
$exclude = @()
$usrgrps = @()
$path = "CN=Users,DC=testenv,DC=int"
$description = ""
$logonscript = ""
$dept = ""

#Step through list of users. Test to see if user exists. If exists, don't do anything. Else, move forward.
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

		#Apply attributes based on department template
		if($user.dept -eq "IVAN"){
			$path = $IVAN_T.node.ou
			$description = $IVAN_T.node.title
			$dept = $IVAN_T.node.dept
			$logonscript = $IVAN_T.node.logon
			$usrgrps = $IVAN_T
		}
		elseif($user.dept -eq "PR"){
			$path = $PR_T.node.ou
			$description = $PR_T.node.title
			$dept = $PR_T.node.dept
			$logonscript = $PR_T.node.logon
			$usrgrps = $PR_T
		}
		elseif($user.dept -eq "CS"){
			$path = $CS_T.node.ou
			$description = $CS_T.node.title
			$dept = $CS_T.node.dept
			$logonscript = $CS_T.node.logon
			$usrgrps = $CS_T
		}
		else{
			$path = "CN=Users,DC=testenv,DC=int"
			$description = ""
			$logonscript = ""
			$usrgrps = @()
		}

		#Actual add user command
		new-aduser -samaccountname $user.username -userprincipalname $user.email -displayname $user.name -name $user.name -givenname $user.fname -surname $user.lname -emailaddress $user.email -homephone "off" -Path $path -AccountPassword (ConvertTo-SecureString -AsPlainText $user.password -Force) -Enabled 1 -description $description -title $description -homedrive $HomeDrive -homedirectory $homedirectory -Department $dept -ScriptPath $logonscript -OtherAttributes @{'pager'="e3"}

		#Add user to groups specified in department template
		foreach($sgrp in $usrgrps.node.sgroups.sgroup){
			WRite-Host "Adding to group: $($sgrp)..."
			Add-ADGroupMember -Members $user.username -Identity $sgrp
		}
		Write-Host "====="
	}

}

<# Old Code. Copies existing template user's groups.
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
#>

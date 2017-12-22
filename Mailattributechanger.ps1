#Licence (c) Jannis Kirschner, 2017 
#Script gets primary mail address, saves it as alias and adds a new primary mail address with a new tld
#Useful for Office365



#Prints welcome Message
write-host "Welcome to AD-Mailchange!"
write-host "Tool by Jannis Kirschner"

#Gets initial values
$ou = "OU=testusers,DC=domainname,DC=ch"  # <----------------- Edit Here
write-host "Please change the ou in sourcecode"
write-host ""
$oldtld = read-host "Enter old TLD for Example(.ch)>"
$newtld = read-host "Enter new TLD for Example(.com)>"
$users =  get-aduser -searchbase $ou  -Filter * | select name
write-host "The following users are being changed: " $users


for($i=0; $i -le $users.count-1; $i++){

	

	#Creating Primary and Secondary Objects
	$user = [string]$users[$i]|%{$_ -replace "@{Name=",""}  |%{$_ -replace "}",""}
	$userobjects = get-aduser -identity $user -properties proxyaddresses 
	$proxyaddresses = $userobjects.proxyaddresses
	$oldprimary = $proxyaddresses | where {$_ -cmatch 'SMTP'}
	$oldsecondary = $proxyaddresses | where {$_ -cmatch 'smtp'}
	




	#Updating the E-Mail Addresses	
	$newprimary = $oldprimary |%{$_ -replace $oldtld,$newtld} 
	$newsecondary = $oldprimary |%{$_ -replace "SMTP","smtp"} 
	$principal = $newprimary |%{$_ -replace "SMTP:",""} 



	#Shows changes
	write-host $user
	write-host "-------------"
	write-host $newprimary 
	write-host $newsecondary
	write-host $oldsecondary
	write-host "Principal: " $principal
	write-host ""
}












write-host "Do you wanna continue?"
$prompt = read-Host "(y/n)>"
if($prompt -ne "y")
{
	write-host ""
	write-host "Bye bye :)"
	read-host " "
	exit
}


for($i=0; $i -le $users.count-1; $i++){

	

	#Creating Primary and Secondary Objects
	$user = [string]$users[$i]|%{$_ -replace "@{Name=",""}  |%{$_ -replace "}",""}
	$userobjects = get-aduser -identity $user -properties proxyaddresses 
	$proxyaddresses = $userobjects.proxyaddresses
	$oldprimary = $proxyaddresses | where {$_ -cmatch 'SMTP'}
	$oldsecondary = $proxyaddresses | where {$_ -cmatch 'smtp'}
	




	#Updating the E-Mail Addresses	
	$newprimary = $oldprimary |%{$_ -replace $oldtld,$newtld} 
	$newsecondary = $oldprimary |%{$_ -replace "SMTP","smtp"} 
	$principal = $newprimary |%{$_ -replace "SMTP:",""} 



	#Shows changes
	write-host $user
	write-host "-------------"
	write-host $newprimary 
	write-host $newsecondary
	write-host $oldsecondary
	write-host "Principal: " $principal
	write-host ""


	#Typeconverts to string
	$setprim = [string]$newprimary
	$setsec = [string]$newsecondary
	$aliases = [string]$oldsecondary

	if($setprim)
	{
		set-aduser -identity $user -clear proxyaddresses
	}
	if($setprim)
	{
		set-aduser -identity $user -add @{proxyAddresses = $setprim}
	}
	if($setsec)
	{
		set-aduser -identity $user -add @{proxyAddresses = $setsec}
	}
	if($aliases)
	{
		set-aduser -identity $user -add @{proxyAddresses = $aliases}
	}
	if($principal)
	{
		set-aduser -identity $user -replace @{UserPrincipalName = $principal}
	}
}

write-host ""
read-host "finished, thanks for using my tool :)"

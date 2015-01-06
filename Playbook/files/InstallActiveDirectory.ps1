[CmdletBinding()]
Param(
[string]$ReplicaOrNewDomain,
[string]$NewDomain,
[string]$NewDomainDNSName,
[string]$DomainNetBiosName,
[int]$ForestLevel,
[int]$DomainLevel,
[string]$InstallDNS,
[string]$ConfirmGc,
[string]$CreateDNSDelegation,
[string]$DatabasePath,
[string]$LogPath,
[string]$SysVolPath,
[string]$SafeModeAdminPassword,
[string]$RebootOnCompletion,
[string]$Username,
[string]$Password,
[string]$ReplicaDomainDNSName
)

#Test for default values
$ReplicaOrNewDomain = if(!$ReplicaOrNewDomain){"Domain"} else {$ReplicaOrNewDomain}
$NewDomain = if(!$NewDomain){"Forest"} else {$NewDomain}
$NewDomainDNSName = if(!$NewDomainDNSName){"example.com"} else {$NewDomainDNSName}				#example.com
$DomainNetBiosName = if(!$DomainNetBiosName){"example"} else {$DomainNetBiosName}				#EXAMPLE
$ForestLevel = if(!$ForestLevel) {"3"} else {$ForestLevel}										#2 - Win2003 #3 - Win2008 #4 -Win2008R2
$DomainLevel = if(!$DomainLevel){"3"}else{$DomainLevel}											#2 - Win2003 #3 - Win2008 #4 -Win2008R2
$InstallDNS = if(!$InstallDNS){"Yes"}else{$InstallDNS}											#Yes/No
$ConfirmGc = if(!$ConfirmGc){"Yes"}else{$ConfirmGc}												#Yes/No
$CreateDNSDelegation =if(!$CreateDNSDeligation){"No"}else{$CreateDNSDelegation}					#Yes/No
$DatabasePath =if(!$DatabasePath){"C:\WINDOWS\NTDS"}else{$DatabasePath}		#"C:\WINDOWS\NTDS"
$LogPath =if(!$LogPath){"C:\WINDOWS\NTDS"}else{$LogPath}			#"C:\WINDOWS\NTDS"
$SysVolPath =if(!$SysVolPath){"C:\WINDOWS\SYSVOL"}else{$SysVolPath}		#"C:\WINDOWS\SYSVOL"
$SafeModeAdminPassword =if(!$SafeModeAdminPassword){"TesTing123!@#"}else{$SafeModeAdminPassword}		
$RebootOnCompletion =if(!$RebootOnCompletion){"No"}else{$RebootOnCompletion}					#Yes/No
$Username = if(!$Username){""}else{$Username}
$Password = if(!$Password){""}else{$Password}
$ReplicaDomainDNSName = if(!$ReplicaDomainDNSName){""}else{$ReplicaDomainDNSName}
trap
{
	Write-Error -ErrorRecord $_
	exit 1;
}
dcpromo.exe /Unattend `
			/ReplicaorNewDomain:$ReplicaOrNewDomain `
			/ReplicaDomainDNSName:$ReplicaDomainDNSName `
			/NewDomain:$NewDomain `
			/ConfirmGc:$ConfirmGc `
			/NewDomainDNSName:$NewDomainDNSName `
			/DomainNetBiosName:$DomainNetBiosName `
			/ForestLevel:$ForestLevel `
			/DomainLevel:$DomainLevel `
			/InstallDns:$InstallDns `
			/CreateDNSDelegation:$CreateDNSDelegation `
			/DatabasePath:$DatabasePath `
			/LogPath:$LogPath `
			/SYSVOLPATH:$SysVolPath `
			/SafeModeAdminPassword:$SafeModeAdminPassword `
			/RebootOnCompletion:No `
			/UserName:$Username `
			/Password:$Password `
			/UserDomain:$NewDomainDNSName

if ($LastExitCode -lt 5) 
{
	#Success and reboot
	#Restart-Computer -Force
	Exit 0;
}
elseif($LastExitCode -eq 77) #77 generally means it's installed already
{
	#TODO Handle better.
	Exit 0;
}
else
{
	throw "DCPromo Failed"
}

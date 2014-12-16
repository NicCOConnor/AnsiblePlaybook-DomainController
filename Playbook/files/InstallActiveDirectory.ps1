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
$SafeModeAdminPassword =if(!$SafeModeAdminPassword){"testing123"}else{$SafeModeAdminPassword}		#I@
$RebootOnCompletion =if(!$RebootOnCompletion){"No"}else{$RebootOnCompletion}					#Yes/No
$Username = if(!$Username){""}else{$Username}
$Password = if(!$Password){""}else{$Password}
$ReplicaDomainDNSName = if(!$ReplicaDomainDNSName){""}else{$ReplicaDomainDNSName}

$exitCode = dcpromo.exe /Unattend `
				/ReplicaorNewDomain:$ReplicaOrNewDomain `
				/ReplicaDomainDNSName:$ReplicaDomainDNSName `
				/NewDomain:$NewDomain `
				/NewDomainDNSName:$NewDomainDNSName `
				/DomainNetBiosName:$DomainNetBiosName `
				/ForestLevel:$ForestLevel `
				/DomainLevel:$DomainLevel `
				/InstallDns:$InstallDns `
				/ConfirmGc:$ConfirmGc `
				/CreateDNSDelegation:$CreateDNSDelegation `
				/DatabasePath:$DatabasePath `
				/LogPath:$LogPath `
				/SYSVOLPATH:$SysVolPath `
				/SafeModeAdminPassword:$SafeModeAdminPassword `
				/RebootOnCompletion:$RebootOnCompletion `
				/UserName:$Username `
				/Password:$Password `
				/UserDomain:$NewDomainDNSName

Write-Host $exitCode
exit 0
[CmdletBinding()]
Param(
[string]$Domain,
[string]$Username,
[string]$Password
)
if($Password)
{
    $secPass = convertto-securestring -String $Password -AsPlainText -Force
}
if (!$Domain){}else{$Domain}
$secCred = New-Object System.Management.Automation.PSCredential($Username, $secPass)
Add-Computer -DomainName $Domain -Restart -Credential $secCred 

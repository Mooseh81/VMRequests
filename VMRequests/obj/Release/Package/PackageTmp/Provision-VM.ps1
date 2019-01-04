param (
   [string]$SPServerName,
   [string]$SPIPAddress,
   [int]$SPvCPU,
   [int]$SPMemory,
   [string]$SPDatacentre,
   [string]$SPNetwork,
   [string]$SPOS
)
 #Load Modules
import-Module VMware.VimAutomation.Core
Import-Module ActiveDirectory

#Test Arguments
#write-output "Server Name is $SPServerName" | Out-String
#write-output "IP Address is $SPIPAddress" | Out-String
#write-output "vCPU is $SPvCPU" | Out-String
#write-output "Memory is $SPMemory" | Out-String
#write-output "Datacentre is $SPDatacentre" | Out-String
#write-output "Network is $SPNetwork" | Out-String
#write-output "OS is $SPOS" | Out-String
$result = $false
#Check AD Object
Try {
        $validName = Get-ADComputer $SPServerName -ErrorAction Stop
    }
	Catch{
	}
	
if($validName){
	write-output "Server $SPServerName already exists please either change the name or delete from AD (Remember to wait for the change to replicate) $validName"
	exit 0
}

#Check IP Address
Try{
	$validIP = Test-Connection -ComputerName $SPServerName
	}
	Catch {
	}

if($validIP){
	write-output "IP Address $SPIPAddress is already in use"
	exit 0
}

   If ($SPDatacentre -eq "DC1 (London)") {
   		$Global:VCS = "DC1VCS01.holmans.com"
		$Global:DCFull = "DC1 (Slough)"
		$Global:Range = "10.144.10."
		$Global:DNSServer = "10.144.10.200"
		$Global:Gateway = "10.144.10.1"
		$Global:BaseOU = "OU=DC1 (London),OU=Servers,DC=holmans,DC=com"
   }
    if ($SPDatacentre -eq "DC2 (Paris)"){
   		$Global:VCS = "DC2VCS01.holmans.com"
		$Global:DCFull = "DC2 (Paris)"
		$Global:Range = "10.133.10."
		$Global:DNSServer = "10.133.10.201"
		$Global:Gateway = "10.133.10.1"
		$Global:BaseOU = "OU=$DCFull,OU=Servers,DC=holmans,DC=com"
	}
	    if ($SPDatacentre -eq "DC3 (Hong Kong)"){
		$Global:VCS = "DC3VCS01.holmans.com"
		$Global:DCFull = "DC3 (Hong Kong)"
		$Global:Range = "10.185.10."
		$Global:DNSServer = "10.185.10.201"
		$Global:Gateway = "10.185.10.1"
		$Global:BaseOU = "OU=$DCFull,OU=Servers,DC=holmans,DC=com"
	}
		if ($SPDatacentre -eq "DC4 (Melbourne)"){
		$Global:VCS = "DC4VCS01.holmans.com"
		$Global:DCFull = "DC4 (Melbourne)"
		$Global:Range = "10.161.10."
		$Global:DNSServer = "10.161.10.201"
		$Global:Gateway = "10.161.10.1"
		$Global:BaseOU = "OU=$DCFull,OU=Servers,DC=holmans,DC=com"
	}
		if ($SPDatacentre -eq "DC5 (Dubai)"){
		$Global:VCS = "DC5VCS01.holmans.com"
		$Global:DCFull = "DC5 (Dubai)"
		$Global:Range = "10.197.10."
		$Global:DNSServer = "10.197.10.201"
		$Global:Gateway = "10.197.10.1"
		$Global:BaseOU = "OU=$DCFull,OU=Servers,DC=holmans,DC=com"
	}
	
	write-output "Connecting to $VCS"
	try{
connect-viserver $Global:VCS -user "HOLMANS\adm_galb" -password "H0ndaD3lS0l"
}catch{
    $ErrorMessage = $_.Exception.Message
write-output "VCS Error: $ErrorMessage"
}

try{
$Datacenter = get-Datacenter $DCFull | Out-String
}catch{
    $ErrorMessage = $_.Exception.Message
write-output "Datacenter Error: $ErrorMessage"
}

try{
$cluster = get-datacenter $DCFull | get-cluster $SPNetwork | select-object first 1
}catch{
    $ErrorMessage = $_.Exception.Message
write-output "Cluster Error: $ErrorMessage"
}

write-output "Datacenter is $Datacenter, Cluster is $cluster"
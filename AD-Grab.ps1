#Show program banner
echo "  _|_|    _|_|_|                  _|_|_|                      _|       " 
echo "_|    _|  _|    _|              _|        _|  _|_|    _|_|_|  _|_|_|    "
echo "_|_|_|_|  _|    _|  _|_|_|_|_|  _|  _|_|  _|_|      _|    _|  _|    _|  "
echo "_|    _|  _|    _|              _|    _|  _|        _|    _|  _|    _|  "
echo "_|    _|  _|_|_|                  _|_|_|  _|          _|_|_|  _|_|_|   "
echo "`n[+] Authored by: r_panov on 07/2018                                  [+]"
echo "[-] 'momentary masters of a fraction of a dot' - Carl Sagan          [-]"

#Display Ad-Grabbing options for user selection
echo "`n[+] Select an option for additional AD grabbing                      [+]"
echo "`t[C]  Current User properties"
echo "`t[1]  Grab current Domain Controller"
echo "`t`t[1a]  Grab all AD Domain Controllers"
echo "`t`t[1b]  Grab specific AD Domain Controller"
echo "`t[2]  Grab all AD Groups **"
echo "`t`t[2a]  Grab specific AD Group"
echo "`t`t[2b]  Grab all AD Group members"
echo "`t`t[2c]  Recursively Grab all AD Group members *"
echo "`t[3]  Grab all AD Organizational Units"
echo "`t`t[3a]  Search for an AD Organizational Unit" #
echo "`t`t[3b]  Grab specific AD Organization Unit"   #
echo "`t`t[3c]  Grab all AD Organization Unit members"
echo "`t[4]  Grab an AD User"
echo "`t`t[4a]  Grab an AD Users' info"
echo "`t`t[4b]  Grab all AD Users ***"
echo "`t[5]  Grab all AD Computers"
echo "`t`t[5a]  Grab a specific AD Computer"
echo "`t`t[5b]  Grab all AD Computers in specific OU"
# Get-ADServiceAccount modules.. believe you Administrative privileges to query service accts.


# Ask for user input
$grabOpt = Read-Host -Prompt "`n[-]  Select option: "

# Run AD-Grabbing module based on user option selection 
if ($grabOpt -eq 'C') {

echo "`nYour current AD properties are ---> "
whoami /user
whoami /LOGONID
whoami /UPN
whoami /FQDN
whoami /PRIV
whoami /groups
get-addomain -Current LoggedOnUser |FT ComputersContainer,UsersContainer,DistinguishedName,DNSRoot,Forest,DomainMode


} 

elseif ($grabOpt -eq '1') {

echo "`n[-] Current AD Domain Controller ---> "
Get-ADDomainController

} 

elseif ($grabOpt -eq '1a') {

echo "`n[-] All AD Domain Controllers ---> "
Get-ADDomainController -Filter * | FT Name,IPv4Address,OperatingSystem,ComputerObjectDN

}

elseif ($grabOpt -eq '1b') {

echo "`n[+] Select a specific AD Domain Controller by its' DNS Host Name (see option 1a, column 'Name')" 
$specDomCon = Read-Host -Prompt "`t[-] Select Domain Controller "

echo "`n[-] AD DC Information for $specDomCon ---> `n"

Get-ADDomainController -Identity $specDomCon

}

 elseif ($grabOpt -eq '2') {

$groupGrab? = Read-Host -Prompt "`n`t [-] Are you sure you want to Grab every AD group? It may take some time... (y/n) "
if ($groupGrab? -eq 'y') {
echo "`n[-] All AD Groups ---> "
Get-ADGroup -Filter * | FT Name,DistinguishedName
}

}

elseif ($grabOpt -eq '2a') {

echo "`n[+] Select a specific AD Group by its' Name (see option 2, column 'Name')" 
$specGroup = Read-Host -Prompt "`t[-] Select Group "

echo "`n[-] Group Information for $specGroup ---> "

Get-ADGroup -Identity $specGroup

}

elseif ($grabOpt -eq '2b') {

echo "`n[+] Select a specific AD Group by its' Name (see option 2, column 'Name')" 
$specGroup = Read-Host -Prompt "`t[-] Select Group "

echo "`n[-] Group Member Information for $specGroup ---> "

Get-ADGroup -Identity $specGroup -Properties member

echo "`n*** Keep drilling down on Groups (i.e. member CN=____ ) to ultimately hit a user base or use option 2c ***`n"

}

elseif ($grabOpt -eq '2c') {

echo "`n[+] Select a specific AD Group by its' Name (see option 2, column 'Name')" 
$specGroup = Read-Host -Prompt "`t[-] Select Group "

$groupGrab? = Read-Host -Prompt "`n`t[-] Are you sure you want to Grab every AD group? It may take some time... (y/n) "

if ($groupGrab? -eq 'y') {
echo "`n[-] Recursive Group Member Information for $specGroup ---> "

Get-ADGroupMember -Identity $specGroup -Recursive
}
}

 elseif ($grabOpt -eq '3') {

$ouGrab? = Read-Host -Prompt "`n`t [-] Are you sure you want to Grab every AD Organizational Unit? It may take some time... (y/n) "
if ($ouGrab? -eq 'y') {
echo "`n[-] All AD OUs ---> "
Get-ADOrganizationalUnit -Filter 'Name -Like "*"' | FT Name,DistinguishedName 
}

}

elseif ($grabOpt -eq '3a') {

echo "`n[+] Search for an Organizational Unit by name (Ex: Administrators)" 
$specOU = Read-Host -Prompt "`t[-] Search "
$specOU2 = "*"+$specOU+"*"

echo "`n[-] Organizational Unit results for search term $specOU ---> "

Get-ADOrganizationalUnit -Filter 'Name -Like $specOU2' | FT Name,DistinguishedName

}

elseif ($grabOpt -eq '3b') {

echo "`n[+] Select a specific AD Organizational Unit by its' Name (see option 3/3a, column 'Distinguished Name')" 
$specOU = Read-Host -Prompt "`t[-] Select Group "

echo "`n[-] Group Information for $specOU ---> "

Get-ADOrganizationalUnit -Identity $specOU
}

elseif ($grabOpt -eq '3c') {

echo "`n[+] Select an AD Organizational Unit by its' Name (see option 3, column 'Distinguished Name')" 
$specOU = Read-Host -Prompt "`t[-] Select OU "

echo "`n[-] Organizational Unit members for $specOU ---> "

Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase $specOU -SearchScope OneLevel | FT Name,DistinguishedName

echo "`n*** Keep drilling down on OUs (i.e. DistinguishedName OU=____ ) to ultimately hit the lowest level OU ***`n"

}

elseif ($grabOpt -eq '4') {

echo "`n[+] Search for an AD User by name (Ex: Joe Smith)" 
$specUser = Read-Host -Prompt "`t[-] Search "
$specUser2 = "*"+$specUser+"*"

echo "`n[-] User results for search term. It may take awhile as it's searching the entire AD... "$specUser" ---> "

dsquery user -name $specUser2

}

elseif ($grabOpt -eq '4a') {

echo "`n[+] Return AD User information by name (Ex: Joe Smith)"
echo "`t[-] Test if AD user exists in option 4 before running option 4a" 

$specUser = Read-Host -Prompt "`t[-] AD User "

echo "`n[-] AD information returned for "$specUser" ---> "

dsquery user -name $specUser | DSGET USER -dn -L
dsquery user -name $specUser | DSGET USER -samid -L
dsquery user -name $specUser | DSGET USER -sid -L
dsquery user -name $specUser | DSGET USER -empid -L
dsquery user -name $specUser | DSGET USER -office -L
dsquery user -name $specUser | DSGET USER -email -L
dsquery user -name $specUser | DSGET USER -tel -L
dsquery user -name $specUser | DSGET USER -dept -L
dsquery user -name $specUser | DSGET USER -mgr -L
dsquery user -name $specUser | DSGET USER -hmdir -L
dsquery user -name $specUser | DSGET USER -profile -L
dsquery user -name $specUser | DSGET USER -disabled -L

}

elseif ($grabOpt -eq '4b') {
$userGrab? = Read-Host -Prompt "`n`t [-] Are you sure you want to Grab every AD user? It may take a long long time... (y/n) "
if ($userGrab? -eq 'y') {
echo "`n[-] All AD Users ---> "
dsquery user -name "*" 
}
}

elseif ($grabOpt -eq '5') {
$compGrab? = Read-Host -Prompt "`n`t [-] Are you sure you want to Grab every AD computer? It may take a long long time... (y/n) "
if ($compGrab? -eq 'y') {
echo "`n[-] All AD Computers ---> "

Get-ADComputer -Filter 'Name -like "*"' -Properties IPv4Address # | FT Name,DNSHostName,DistinguishedName,IPv4Address -A
}
}

elseif ($grabOpt -eq '5a') {

echo "`n[+] Select a specific AD Computer by its' Name (see option 5, property 'Distinguished Name')" 
$specComp = Read-Host -Prompt "`t[-] Select Computer "

echo "`n[-] Computer information for $specComp ---> "

Get-ADComputer -Identity $specComp -Properties *
}

elseif ($grabOpt -eq '5b') {

echo "`n[+] Select all AD Computers in a specific OU (see option 3 and 3a, Column 'Distinguished Name')" 
$specOU = Read-Host -Prompt "`t[-] Select OU  "

echo "`n[-] AD Computers in $specOU ---> "

Get-ADComputer -LDAPFilter "(name=*)" -SearchBase $specOU
}

else {

echo "You've Selected an invalid option."

}














# Special Message from author: SWYgeW91ciByZWFkaW5nIHRoaXMsICJTb3JyeSB0byB3YXN0ZSB5b3VyIHRpbWUgOyki




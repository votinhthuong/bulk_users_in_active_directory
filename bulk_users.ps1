# Import active directory module for running AD cmdlets
Import-Module activedirectory
  
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv C:\bulk_users1.csv

$Domain = Get-ADDomain 
$dc1 = $Domain.DNSRoot.split('.')[0]
$dc2 = $Domain.DNSRoot.split('.')[1]

foreach ($User in $ADUsers)
{
    $oufull = $User.ou
    $ou1 = $User.ou1
    #Write-Warning $User.ou
    [string] $Path = "$oufull"
    #Write-Host $Path
    if([adsi]::Exists("LDAP://$Path"))
    {
        Write-Warning "Da ton tai $ou1 trong AD!"
    }
    else
    {       
        New-ADOrganizationalUnit -Name $ou1 -Path "DC=$dc1,DC=$dc2"

    }
}

foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname
	$Lastname 	= $User.lastname
	$OU 		= $User.ou #This field refers to the OU the user account is to be created in
    $email      = $User.email
    $streetaddress = $User.streetaddress
    $city       = $User.city
    $zipcode    = $User.zipcode
    $state      = $User.state
    $country    = $User.country
    $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department
    $Password = $User.Password


	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@$dc1.$dc2" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True            
	}
}




#Loop through each row containing user details in the CSV file 

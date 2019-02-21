# Import active directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv C:\bulk_users1.csv

$Domain = Get-ADDomain 
$dc1 = $Domain.DNSRoot.split('.')[0]
$dc2 = $Domain.DNSRoot.split('.')[1]


#Loop through each row containing user details in the CSV file 
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
    $country    = $User.country
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department

    $ou=$User.ou
    
	#Check to see if the user already exists in AD
	if (Get-ADUser -F {SamAccountName -eq $Username})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username already exist in Active Directory."
	}
	else
	{
        
        if("LDAP://OU=$ou,DC=$dc1,DC=$dc2")
        {
            Write-Warning "A Organization Unit with name $ou already exist in Active Directory."
        }
        else
        {       
            New-ADOrganizationalUnit -Name $ou -Path "DC=$dc1,DC=$dc2" 
        }
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@votinhthuong.tech" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -Path $OU `
            -City $city `
            -Company $company `
            -StreetAddress $streetaddress `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $True
            
	}
}

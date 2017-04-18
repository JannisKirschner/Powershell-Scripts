#Website to add params param array while has
#copyright ascii art



#Ascii Art
$welcome = "      
                  ____ ______     ______     _    ____        _   _ ____  _____ ____  ____  
                 / ___/ ___\ \   / /___ \   / \  |  _ \      | | | / ___|| ____|  _ \/ ___| 
                | |   \___ \\ \ / /  __) | / _ \ | | | |_____| | | \___ \|  _| | |_) \___ \ 
                | |___ ___) |\ V /  / __/ / ___ \| |_| |_____| |_| |___) | |___|  _ < ___) |
                 \____|____/  \_/  |_____/_/   \_\____/       \___/|____/|_____|_| \_\____/ 
                                                   https://github.com/JannisKirschner `n `n "  
 



#Initialises the script with a message
Write-Host $welcome
Write-Host "Welcome to CSV2AD-USERS - The tool to create AD-Users out of CSV files" `n
Write-Host "Please choose a file to import... " 


#Opens the "choose file" dialog box
Function getfilename($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

#Manual selection of delimiters
function manualDelimiter($delimiter) {
    #Select the delimiter to seperate the parameters
    Write-Host "Please select a delimiter (0 = ;  |  1 = ,)"

    #Inputs the delimiter style (with error handling)
    While($True){
        $delimiterchoice = Read-Host "Delimiter>"
        If($delimiterchoice -eq 0){$delimiter = ";" ; break}
        ElseIf($delimiterchoice -eq 1){$delimiter = "," ; break}
        Else{Write-Host "Bad input!" -foreground red}
    }
    return $delimiter
}


#Measures the size of both delimiter choices
$filepath = getfilename("C:\\")
$delimiterTest = Get-Content $filepath
$semicolondelimiter = ($delimiterTest.toCharArray() |Where-Object {$_ -eq ';'} | Measure-Object).count
$commadelimiter = ($delimiterTest.toCharArray() |Where-Object {$_ -eq ','} | Measure-Object).count

#Sets the bigger one as delimiter or lets you choose one in case of an error
if($semicolondelimiter -gt $commadelimiter) {$delimiter = ';'}
elseIf($commadelimiter -gt $semicolondelimiter){$delimiter = ','}
elseIf($semicolondelimiter -eq $commadelimiter){
    Write-Host "Couldn't find out delimiter (Same Size)! Please enter manually" -foreground red
    $delimiter = manualDelimiter($delimiter)}

else{
    Write-Host "Couldn't find out delimiter (Unknown Error)! Please enter manually" -foreground red
    $delimiter = manualDelimiter($delimiter)}

#Gets filename
$filename = (Get-ChildItem $filepath).BaseName 
$fileextension = (Get-ChildItem $filepath).Extension

#Writes filename and delimiter
Write-Host "Your file is: " $filename$fileextension
Write-Host `n
Write-Host "Your delimiter is:" $delimiter
Write-Host "---------------------"

#Imports the CSV-File
$adparams = Import-CSV $filepath -delimiter $delimiter

#Asks for permission to create the users (with error handling)
Write-Host "Are you sure you want to create the following user(s): " `n

Foreach($user in $adparams){
    $name = $user.Name
    Write-Host $name
}

While($True){
    $prompt = Read-Host "(y/n)>"
    $proceed = "y"
    $cancel = "n"


    If($prompt -eq $proceed){

            #Inputs the domain name (with error handling)
            #Please enter it <domain>.<top-level domain>
            While($True){
            
                $domain = Read-Host "Please enter (full) domain-name> "
                $verifydomain = Read-Host "Please reenter your domain-name> "
                if($domain.contains('.')){
                    if($domain -eq $verifydomain){break}
                    else{Write-Host "Domains are not matching, please try again!" -foreground red }}
                     
                else{Write-Host "It seems there's no TLD, try again please!" -foreground red}
            }
            
            #Inputs the default user password (with error handling)
            While($True){
            
                $passwordinput = Read-Host "Please enter the default password> " 
                $verifypassword = Read-Host "Please reenter the default password> " 
                if($passwordinput -eq $verifypassword){break}
                else{Write-Host "Passwords are not matching, please try again!" -foreground red }
            }

            
            #Inputs the Organistation-Unit name (with error handling)
            While($True){
            
                $ouname = Read-Host "Please enter the OU-Name> " 
                $verifyou = Read-Host "Please enter the OU-Name again> " 
                if($ouname -eq $verifyou){break}
                else{Write-Host "OU-Names are not matching, please try again!" -foreground red }
                
            }


            #Prepares the domain path 
            $tempdomain = $domain.split(".") 
            $oudomain = $tempdomain[0]
            $outld = $tempdomain[1]
            
            
            Write-Host "Creating AD-User(s)..." -foreground yellow `n `n 

        #Processes the recently created statements and creates the users
        #try{
            Foreach($user in $adparams ){


                #Initialises the variables
                $name = $user.Name            
                $givenname = $user.Vorname
                $surname = $user.Nachname
                $email = $user.Email
                $password = $passwordinput | ConvertTo-SecureString -AsPlainText -Force
                $displayname = $givenname + " " + $surname  #evtl csv 
                $userprincipalname = $name + "@" + $domain
                $OU = "OU=" + $ouname + ",DC=" + $oudomain + ",DC=" + $outld
                          
                
                #Shows the neat loading animation (remove to speed up the process)
                Write-Host "Creating User: "$name -nonewline
                For($i=0; $i -le 3; $i++){Write-Host "." -nonewline;  Start-Sleep -s 0.5}
                Write-Host " "
                
                #Creates the AD-Users by taking the recent variables and their corresponding parameters
                New-ADUser -SamAccountName $name -Name $name -GivenName $givenname -Surname $surname -EmailAddress $email -DisplayName $displayname -UserPrincipalName $userprincipalname -Path $ou -AccountPassword $password -ChangePasswordAtLogon $False -PasswordNeverExpires $True -Enabled $True
                }#}

        #catch [System.Exception] {
        
        #if()
        
        #}

         #catch [System.Exception] {
        
        #if() # TODO Catchmessages compare + silent continue
        
        #}



        
         #catch [ADIdentityAlreadyExistsException] {
          #  Write-Host "Error: User already exists!" -foreground red 
         #   }

        #catch [ParameterBindingValidationException] {
           # Write-Host "Error: There are no users in the csv file!" -foreground red
          #  Write-Host "Did you use the correct delimiter?" -foreground red
         #   break
        #}

        
        #catch [ADPasswordComplexityException] {
          #  Write-Host "Error: The chosen default password is too weak!" -foreground red
         #   break 
        #}
          
        #catch [ADException] {
          #  If($Error.contains()){Write-Host "User already in another Organistation-Unit" -foreground red}
         #   break
        #}

        

        #catch {
          # Write-Host "An error occured..." -foreground red
         #  Write-Host($error[0].ToString() ) -foreground red 
        #   break
        #}

                
         Write-Host `n"****************************"
         Write-Host    "User(s) successfully created" -foreground green
         Write-Host    "****************************"
            break} 

    ElseIf($prompt -eq $cancel) {
                Write-Host `n "Goodbye! Thanks for using my script!" -foreground yellow
                break}

    Else{
        Write-Host "Bad input!" -foreground red}
}

#WinInf is a tool to get various system informations 
#Author: Jannis Kirschner
#Copyright: Jannis Kirschner, 2017 
#Licence: GPL 3

Write-Host "*****************************"
Write-Host "*         WinInf            *"
Write-Host "*  Computer Informations    *"
Write-Host "*github.com/JannisKirschner *"
Write-Host "*                           *"
Write-Host "*****************************" `n
Write-Host "Username:     " $env:UserName
Write-Host "Domain:       " $env:UserName
Write-Host "Computername: " $env:UserName
Write-Host "Manufacturer & Model Information"
gwmi win32_computersystem

Write-Host "BIOS Information"   
Write-Host "----------------"`n
gwmi win32_bios

Write-Host "System Type"
Write-Host "----------------"`n
gwmi win32_computersystem  | select-object -property systemtype

Write-Host "Processor Information"
Write-Host "----------------"`n
gwmi win32_processor

Write-Host "Extended Processor Information"
Write-Host "----------------"`n
gwmi win32_processor | Select-Object -Property [a-z]*

Write-Host "OS Information"
Write-Host "----------------"`n
gwmi win32_operatingsystem
gwmi win32_operatingsystem -computername . | select-object -property BuildNumber,BuildType,OSType,ServicePackMajorVersion,ServicePackMinorVersion


Write-Host "User Information"
Write-Host "----------------"`n
gwmi win32_operatingsystem -computername . | Select-Object -Property *user*

Write-Host "Hotfix Information"
Write-Host "----------------"`n
gwmi win32_quickfixengineering -computername .

Write-Host "Disk Information"
Write-Host "----------------"`n
gwmi win32_logicaldisk -filter "DriveType=3" -computername .

Write-Host "Extended Disk Information"
Write-Host "----------------"`n
gwmi win32_logicaldisk

Write-Host "Logon Session Information"
Write-Host "----------------"`n
gwmi win32_logonsession
gwmi win32_computersystem -property username -computername .

Write-Host "Time Information"
Write-Host "----------------"`n
gwmi win32_localtime -computername . | select-object -property [a-z]*


Write-Host "Service Information"
Write-Host "----------------"`n
gwmi win32_service -computername . | format-table -property Status,Name,DisplayName -autosize -wrap

Write-Host "`nThanks for using my script"
Read-Host "Enter to exit>"

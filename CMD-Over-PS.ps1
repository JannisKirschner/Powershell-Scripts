#CMD-Over-PS.ps1
#Open CMD over powershell

#$programm="cmd.exe";
#$parameters=@("/C";"YOURCOMANDHERE";" >c:\temp\FILENAME.txt");
#Start-Process -Verb runas $programm $parameters;
#gc c:\temp\FILENAME.txt;


#Example:

$programm="cmd.exe";
$parameters=@("/C";"echo success";" >c:\temp\results.txt");
Start-Process -Verb runas $programm $parameters;
gc c:\temp\results.txt;


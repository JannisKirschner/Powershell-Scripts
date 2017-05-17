rem Drag and drop your wininf file to get a path and your results in a file

@ECHO OFF

set /p wininfpath= "Drag and drop your WinInf file:  "
powershell -noexit "& " "%wininfpath%" >> results.txt
exit

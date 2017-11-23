#Backup removal tool
#(c)Jannis Kirschner
#Licence 2017, GPL 3.0

#Just create a new event and use this script to automatically remove the oldest backups that are more than 'n'.

$maxbackup = 10 #The backups you want to keep
$suffix = "nbd" #The suffix of your backup software
$backuppath = "C:\Path\to\backups\"

$foldersize = (get-childitem $backuppath  -name -filter "*.$suffix"  | Measure-Object).count

if($foldersize -gt $maxbackup){								
	get-childitem $backuppath -name -filter "*.$suffix" | sort LastWriteTime -Descending | select -first ($foldersize - $maxbackup) | remove-item
}

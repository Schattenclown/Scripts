# curl and zip needs to be installed
# sudo apt install zip
# sudo apt install curl

#this script zips a directory and copys it to an smb share with an username and password for the smb share

#this is the path where the local zip will end up being created you may want to have this script at the same location
backupdir="/home/minecraft/minecraft_backups"

#this is the path to the folder
#example "/home/minecraft"
dir2zip1="/home/minecraft"

#this is the folder that will be ziped
#example "server"
dir2zip2="server"

#this is the path that will be ziped you can exclude subdirectorys in the zip command in line ?? 
#example would end up being "/home/minecraft/server"
dir2zip3=$dir2zip1/$dir2zip2

#go in the dir
cd $dir2zip3

#creating a var with the timestamp
date=$(date +'%Y-%m-%d__%H__%M__')
#creating a var with the foldername
foldername=$dir2zip2
#combining the timestamp and foldername in one var
zipname=$date$foldername

#zip command
#
#if you add this to the end of the command you can exclude spesific subfolder and all there subfolders and content
#-x backups/**\*
zip -r $backupdir/$zipname.zip * -x backups/**\*

#this is the curl command that will upload the zip to the smb share
#
#here would go your username and password for the smb share the : needs to be in the command and not removed
#-u <username>:<password>
#
#this will be the location to the smb share the path has to exsist already
#smb://192.168.69.69/path/to/location/
curl --upload-file $backupdir/$zipname.zip -u <username>:<password> smb://192.168.69.69/path/to/location/
#!/bin/zsh

theFiles=("${(@f)$(find $HOME/(Desktop|Documents) ! -newermt "1980-01-01")}") 
# https://unix.stackexchange.com/a/29748/599230

for f in $theFiles
do
	echo "$f" >> $HOME/Desktop/OneDrive-FileDates.txt
 	theTime=$(date -r "$f" +%H%M.%S)
 	echo $theTime
 	# stat "$f"
 	touch -t 19800101$theTime "$f"
 	# stat "$f" 	
done

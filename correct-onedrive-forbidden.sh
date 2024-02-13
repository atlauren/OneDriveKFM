#!/bin/zsh
# https://github.com/atlauren/OneDriveKFM/

# OneDrive issues with filenames
# https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa
# zsh
# https://zsh.sourceforge.io/Doc/Release/zsh_toc.html
# https://zsh.sourceforge.io/Doc/Release/Expansion.html
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zmv
# https://stackoverflow.com/a/41508466/20266908

if (( # == 0 )) ; then
	echo "usage: correct-onedrive-forbidden.sh <cmd>"
	echo ""
	echo "  --dry-run    Report only; make no changes."
	echo "  --commit     Write changes to files."
	echo ""
	exit 0
fi

if [[ ${1} = "--dry-run" ]] ; then
	theFlag="n"     # do Nothing
	theTouch="no-go"
elif [[ ${1} = "--commit" ]] ; then
	theFlag="v"     # output Verbose
	theTouch="go"
else 
	echo "Should not land here."
	exit 1
fi

theHome=$(dscl . read /Users/$USER NFSHomeDirectory | awk '{print $2}')
theRoot=$theHome/Desktop/
theName=OneDrive-Renamed
theOutput=$theName.txt
theCSV=$theName.csv

autoload zmv

zmv $theRoot'(OneDrive-Renamed).(txt|csv)(#qN)' $theRoot'$1_$(stat -f %Sc -t %F_%H-%M-%S $f).$2'

touch $theRoot$theOutput

for q in / . ; do
# (#q/) directories
# (#q.) files

	for i in Desktop/ Documents/ ; do
	
		# leading spaces -- substitute with "_"
		zmv -$theFlag $theHome/$i'(**/) (*)(#q'$q')(#qN)' $theHome/$i'$1_$2' >> $theRoot$theOutput
		
		# trailing spaces -- substitute with "_"
		zmv -$theFlag $theHome/$i'(**/)(*) (#q'$q')(#qN)' $theHome/$i'$1$2_' >> $theRoot$theOutput
		
		# illegal characters -- substitute with "_"
		# " * : < > ? / \ | %
		# https://unix.stackexchange.com/a/767152/599230
		zmv -$theFlag $theHome/$i'(**/)(*)(#q'$q')(#qN)' $theHome/$i'$1${(S)2//([\\:\|><\?\*\%"\""])/_}' >> $theRoot$theOutput
		
		# CON PRN AUX NUL -- prepend with "_"
		zmv -$theFlag $theHome/$i'(**/)(AUX|CON|NUL|PRN)(#q'$q')(#qN)' $theHome/$i'$1_$2' >> $theRoot$theOutput
		
		# COM[0-9], LPT[0-9] -- prepend with "_"
		zmv -$theFlag $theHome/$i'(**/)(COM|LPT)([0-9])(#q'$q')(#qN)' $theHome/$i'$1_$2$3' >> $theRoot$theOutput
	
		# _vti_ -- remove "_"
		zmv -$theFlag $theHome/$i'(**/)_(vti)_(#q'$q')(#qN)' $theHome/$i'$1$2' >> $theRoot$theOutput
		
		# .lock -- replace . with "_"
		zmv -$theFlag $theHome/$i'(**/).(lock)(#q'$q')(#qN)' $theHome/$i'$1_$2' >> $theRoot$theOutput
	
		# desktop.ini -- replace . with "_"
		zmv -$theFlag $theHome/$i'(**/)(desktop).(ini)(#q'$q')(#qN)' $theHome/$i'$1$2_$3' >> $theRoot$theOutput
		
		# files begining ~$ -- replace ~$ with "__"
		zmv -$theFlag $theHome/$i'(**/)\~$(*)(#q.)(#qN)' $theHome/$i'$1__$2' >> $theRoot$theOutput	
	done

done

awk -f /tmp/zmv2csv.awk $theRoot$theOutput > $theRoot$theCSV

# File Dates predating 1980-01-01
# https://en.wikipedia.org/wiki/File_Allocation_Table
# https://superuser.com/a/797493

zmv $theRoot'(OneDrive-FileDates).(txt)(#qN)' $theRoot'$1_$(stat -f %Sc -t %F_%H-%M-%S $f).$2'

theFiles=("${(@f)$(find $theHome/(Desktop|Documents) ! -newermt "1980-01-01")}") 
# https://unix.stackexchange.com/a/29748/599230

for f in $theFiles
do
	echo "$f" >> $theHome/Desktop/OneDrive-FileDates.txt
 	theTime=$(date -r "$f" +%H%M.%S)
 	if [[ $theTouch = "go"]] ; then
 		touch -t 19800101$theTime "$f"
 	fi
done


# end

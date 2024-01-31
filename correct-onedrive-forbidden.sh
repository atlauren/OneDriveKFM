#!/bin/zsh
# https://github.com/atlauren/OneDriveKFM/
# atlauren@uci.edu
# 
# https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa
# https://zsh.sourceforge.io/Doc/Release/zsh_toc.html
# https://zsh.sourceforge.io/Doc/Release/Expansion.html
# https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zmv
# https://stackoverflow.com/a/41508466/20266908

theRoot=$HOME/Desktop/
theName=OneDrive-Renamed
theOutput=$theName.txt
theCSV=$theName.csv

autoload zmv

zmv $theRoot'(OneDrive-Renamed).(txt|csv)(#qN)' $theRoot'$1_$(stat -f %Sc -t %F_%H-%M-%S $f).$2'

#rm $theRoot$theOutput
touch $theRoot$theOutput

for q in / . ; do
# (#q/) directories
# (#q.) files

	for i in Desktop/ Documents/ ; do
	
		# leading spaces -- substitute with "_"
		zmv -n $HOME/$i'(**/) (*)(#q'$q')(#qN)' $HOME/$i'$1_$2' >> $theRoot$theOutput
		
		# trailing spaces -- substitute with "_"
		zmv -n $HOME/$i'(**/)(*) (#q'$q')(#qN)' $HOME/$i'$1$2_' >> $theRoot$theOutput
		
		# illegal characters -- substitute with "_"
		# " * : < > ? / \ | %
		# https://unix.stackexchange.com/a/767152/599230
		zmv -n $HOME/$i'(**/)(*)(#q'$q')(#qN)' $HOME/$i'$1${(S)2//([\\:\|><\?\*\%"\""])/_}' >> $theRoot$theOutput
		
		# CON PRN AUX NUL -- prepend with "_"
		zmv -n $HOME/$i'(**/)(AUX|CON|NUL|PRN)(#q'$q')(#qN)' $HOME/$i'$1_$2' >> $theRoot$theOutput
		
		# COM[0-9], LPT[0-9] -- prepend with "_"
		zmv -n $HOME/$i'(**/)(COM|LPT)([0-9])(#q'$q')(#qN)' $HOME/$i'$1_$2$3' >> $theRoot$theOutput
	
		# _vti_ -- remove "_"
		zmv -n $HOME/$i'(**/)_(vti)_(#q'$q')(#qN)' $HOME/$i'$1$2' >> $theRoot$theOutput
		
		# .lock -- replace . with "_"
		zmv -n $HOME/$i'(**/).(lock)(#q'$q')(#qN)' $HOME/$i'$1_$2' >> $theRoot$theOutput
	
		# desktop.ini -- replace . with "_"
		zmv -n $HOME/$i'(**/)(desktop).(ini)(#q'$q')(#qN)' $HOME/$i'$1$2_$3' >> $theRoot$theOutput
		
		# files begining ~$ -- replace ~$ with "__"
		zmv -n $HOME/$i'(**/)\~$(*)(#q.)(#qN)' $HOME/$i'$1__$2' >> $theRoot$theOutput	
	done

done

awk -f ./zmv2csv.awk $theRoot$theOutput > $theRoot$theCSV

# end

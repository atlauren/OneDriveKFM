#!/bin/zsh
# https://github.com/atlauren/OneDriveKFM/
# atlauren@uci.edu
# https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa

autoload zmv

# substitute leading spaces with "_"
zmv -n '(**/) (*)' '$1_$2'

# substitute trailing spaces with "_"
zmv -n '(**/)(*) ' '$1$2_'

# substitute illegal characters with "_"
# " * : < > ? / \ | %
# https://unix.stackexchange.com/a/767152/599230
zmv -n '(**/)(*)' '$1${(S)2//([\\:\|><\?\*\%"\""])/_}'

# prepend with "_"
# CON PRN AUX NUL
zmv -n '(**/)(AUX|CON|NUL|PRN)' '$1_$2'

# prepend with "_"
# COM0 - COM9
# LPT0 - LPT9
zmv -n '(**/)(COM|LPT)([0-9])' '$1_$2$3'

# remove "_"
# _vti_
zmv -n '(**/)_(vti)_' '$1$2'


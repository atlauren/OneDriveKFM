# OneDriveKFM
Replace OneDrive-Forbidden Characters

These shell scripts look for file and folder names known to be forbidden by OneDrive; characters forbidden by OneDrive are replaced with understores (`_`). Only the Desktop and Documents folders are targeted.  

In addition, files with dates predating 1980-01-01 are updated to 1980-01-01.  This change accomodates restrictions in the FAT file system, and a data presentation issue in Windows Explorer.

Output files are written to ~/Desktop:

| File | Description |
|---|---|
| OneDrive-Renamed.txt | Direct output from `zmv`. |
| OneDrive-Renamed.csv | An `awk`-processed CSV version of the same file. |
| OneDrive-FileDates.txt | A list of files whose file dates were changed. |

The scripts are written in `zsh`, taking advantage of `zsh`'s file globbing and the `zmv` function.

The script assumes it is executed by the user account owning the files.

Released under MIT license to benefit the Macadmin community.


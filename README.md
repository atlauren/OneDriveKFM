# OneDriveKFM
## Replace [OneDrive-Forbidden](https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa) Characters

These shell scripts look for file and folder names known to be forbidden by OneDrive; characters forbidden by OneDrive are replaced with underscores (`_`). 

Only the Desktop and Documents folders are targeted.  The scripts are written in `zsh`, taking advantage of `zsh`'s file [globbing](https://en.wikipedia.org/wiki/Glob_(programming)) and the `zmv` function. In addition, files with dates predating 1980-01-01 are updated to 1980-01-01; this change accommodates restrictions in the FAT file system and a data presentation issue in Windows Explorer.

| Script | Description |
|---|---|
| onedrive-forbidden-characters-test.sh | Runs `zmv -n` "what if" mode. Does not `touch` files. |
| onedrive-forbidden-characters.sh | Writes changes to files. |

Output files are written to ~/Desktop:

| Output File | Description |
|---|---|
| OneDrive-Renamed.txt | Direct output from `zmv`. |
| OneDrive-Renamed.csv | An `awk`-processed CSV version of the same file. |
| OneDrive-FileDates.txt | A list of files whose file dates were changed. |

The script assumes it is executed by the user account owning the files.

## ToDo
* Unify into one .sh script.
  - `-safe` and `-commit` options, required.
* Fix directory references
* Add .awk file to docs list
* Document needing both .sh and .awk files in the same directory.
 

Released under MIT license to benefit the Mac Admin community.


# define installer name
OutFile "ricochet.exe"

# set desktop as install directory
InstallDir $DESKTOP\Ricochet-Refresh

# default section start
Section

# define output path
SetOutPath $INSTDIR

# specify file to go in output path
File ricochet-refresh.exe
File tor.exe

SectionEnd
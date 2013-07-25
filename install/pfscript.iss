[Setup]
AppName=PF Script
AppVersion=4.0b2
AppVerName=PF Script v4.0 beta2
AppID={{B717A500-FD48-4599-983D-55A6120AD233}}
AppPublisher=Pokemon-France.com
AppPublisherURL=http://www.pokemon-france.com/
AppComments=Réparer/Désinstaller le PF Script
DefaultDirName="{pf}\PF Script"
DefaultGroupName=PF Script
Compression=lzma2
SolidCompression=no
SourceDir=C:\Pokemon-France Script - Copie\export\Pokémon France Script v3.0\
UninstallDisplayIcon="install\uninstallball.ico"
UninstallIconFile="install\uninstallball.ico"
OutputBaseFilename=setup-PFScript
OutputDir=install
AllowRootDirectory=yes
AllowNoIcons=yes
AppModifyPath="{app}\repair.exe"
DisableDirPage=auto
DisableProgramGroupPage=auto
LicenseFile=license.txt
UninstallDisplayName=Pokémon France Script
SetupIconFile=install\installball.ico
WizardImageFile=install\wizardfile.bmp
WizardSmallImageFile=install\smallwizardicon.bmp
ChangesAssociations=yes
PrivilegesRequired=admin

[Types]
Name: "full"; Description: "Complète"
Name: "minimal"; Description: "Minimale"
;Name: "dev"; Description: "Développeur"
Name: "custom"; Description: "Personnalisée"; Flags: iscustom

[Components]
Name: "main"; Description: "Composants principaux"; Types: full minimal custom; Flags: fixed
;Name: "main"; Description: "Composants principaux"; Types: full ; Flags: fixed
;Name: "help"; Description: "Fichiers d'aide"; Types: full dev
Name: "images"; Description: "Bibliothèques d'images"; Types: full
; Name: "fonts"; Description: "Polices spéciales"; Types: full
Name: "themes"; Description: "Thèmes"; Types: full
Name: "themes\nnscript"; Description: "Thèmes NNScript"; Types: full
Name: "themes\mts"; Description: "Thèmes Standard"; Types: full
;Name: "tools"; Description: "Outils de développement"; Types: dev

[Tasks]
Name: desktopicon; Description: "Créer une icône sur le bureau"; GroupDescription: "Icônes supplémentaires"; Components: main; Flags: unchecked
; Name: associate; Description: "Associer les fichiers .mrc avec mEditor?"; GroupDescription: "Autres"; Components:tools; Flags: unchecked

[Dirs]
Name: "{app}"; Permissions: users-modify
Name: "{app}\logs"
Name: "{app}\download"

[Files]
Source: "mirc.exe"; DestDir: "{app}"; Components: main; Flags: restartreplace; Tasks:desktopicon
Source: "C:\Pokemon-France Script - Copie\Pokémon France Script v3.0\alias\*"; DestDir: "{app}\alias"; Excludes: ".svn/*,*.svn/*"; Components: main; Flags: ignoreversion sortfilesbyname sortfilesbyextension recursesubdirs
Source: "*.ini"; DestDir: "{app}"; Components: main; Excludes: "toolbar.ini"; Flags: onlyifdoesntexist;
Source: "data\*"; DestDir: "{app}\data"; Components: main; Flags: onlyifdoesntexist recursesubdirs sortfilesbyextension sortfilesbyname
Source: "C:\Pokemon-France Script - Copie\Pokémon France Script v3.0\script\*"; DestDir: "{app}\script"; Excludes: ".svn/*,*.svn/*,mircart/*,mircart.mrc"; Components: main; Flags: recursesubdirs sortfilesbyextension sortfilesbyname ignoreversion
Source: "images\*"; DestDir: "{app}\images"; Excludes: "*.bmp"; Components: main; Flags: sortfilesbyextension sortfilesbyname
Source: "sounds\*"; DestDir: "{app}\sounds"; Components: main; Flags: sortfilesbyextension sortfilesbyname recursesubdirs
;Source: "help\*"; DestDir: "{app}\help"; Excludes: "help\*"; Components: help; Flags: recursesubdirs sortfilesbyextension sortfilesbyname
;Source: "*.chm"; DestDir: "{app}"; Components: help; Flags: sortfilesbyname
;Source: "dstudio\*"; DestDir: "{app}\tools\dstudio"; Components: tools; Flags: recursesubdirs sortfilesbyextension
;Source: "meditor\*"; DestDir: "{app}\tools\meditor"; Components: tools; Flags: sortfilesbyextension
;Source: "images\bars\HeartGold\*"; DestDir: "{app}\images\bars\HeartGold"; Components: images; Flags: sortfilesbyextension sortfilesbyname
Source: "images\bars\*"; DestDir: "{app}\images\bars"; Components: images; Flags: sortfilesbyextension sortfilesbyname recursesubdirs
Source: "themes\nnscript\*"; DestDir: "{app}\themes\nnscript"; Components: themes\nnscript; Flags: sortfilesbyname sortfilesbyextension recursesubdirs
Source: "themes\mts\*"; DestDir: "{app}\themes\mts"; Components: themes\mts; Flags: sortfilesbyname sortfilesbyextension recursesubdirs
;Source: "themes\PFTheme\*"; DestDir: "{app}\themes\*"; Components: themes\mts; Flags: sortfilesbyname sortfilesbyextension recursesubdirs
Source: "*"; DestDir: "{app}"; Excludes: "*.ini,*/*,install/*"; Components: main

[Icons]
Name: "{group}\PF Script"; Filename: "{app}\mirc.exe"; WorkingDir: "{app}"; Comment: "Lancer le PF Script"; IconFilename: "{app}\images\masterIRC2.ico"
Name: "{group}\Aide du PF Script"; Filename: "{app}\pfscript.chm"
Name: "{group}\Page d'accueil"; Filename: "http://www.pokemon-france.com/script"
Name: "{group}\Désinstaller PF Script"; Filename: "{uninstallexe}"; IconFilename: "install\uninstallball.ico"
Name: "{userdesktop}\PF Script"; Filename: "{app}\mirc.exe"; WorkingDir: "{app}"; Tasks: desktopicon; Comment: "Lancer le PF Script"; IconFilename: "{app}\images\masterIRC2.ico"

[Languages]
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"

[UninstallDelete]
Type: files; Name: "{app}\toolbar.ini"
Type: filesandordirs; Name: "{app}\script"

[Run]
Filename: "{app}\mirc.exe"; Description: "Démarrer le PF Script"; WorkingDir: "{app}"; Flags: postinstall skipifsilent nowait runmaximized


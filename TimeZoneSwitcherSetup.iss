[Setup]
AppName=Time Zone Switcher
AppVersion=1.0
DefaultDirName={autopf}\Time Zone Switcher
DefaultGroupName=Time Zone Switcher
OutputDir=Output
OutputBaseFilename=mysetup
SetupIconFile=app.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x86 x64
ArchitecturesInstallIn64BitMode=x64
DisableDirPage=no
DisableProgramGroupPage=yes
CreateAppDir=yes
UsePreviousAppDir=yes
UsePreviousGroup=yes
UsePreviousSetupType=yes
UsePreviousTasks=yes
UsePreviousUserInfo=yes
; Use correct parameters to control silent installation behavior
SilentInstall=no
UsePreviousLanguage=yes
; Add this line to resolve user region warning
ShowLanguageDialog=auto
AppPublisher=Your Company
AppPublisherURL=https://yourwebsite.com
AppSupportURL=https://yourwebsite.com
AppUpdatesURL=https://yourwebsite.com
LicenseFile=
; Remove obsolete quick launch bar option
DisableStartupPrompt=yes
DisableReadyMemo=no
DisableReadyPage=no
DisableFinishedPage=no
DisableWelcomePage=no
ShowTasksTreeLines=yes
AllowNoIcons=yes
AlwaysShowDirOnReadyPage=yes
AlwaysShowGroupOnReadyPage=yes
ShowComponentSizes=yes
FlatComponentsList=yes
ShowUndisplayableLanguages=yes
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
; Remove quick launch bar icon

[Files]
Source: "bin\Release\net6.0-windows\win-x86\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Time Zone Switcher"; Filename: "{app}\TimeZoneSwitcherApp.exe"
Name: "{group}\{cm:UninstallProgram,Time Zone Switcher}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Time Zone Switcher"; Filename: "{app}\TimeZoneSwitcherApp.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\TimeZoneSwitcherApp.exe"; Description: "{cm:LaunchProgram,Time Zone Switcher}"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  // If in silent installation mode, skip .NET check
end;

; Basic Information
#define MyAppName "Time Zone Switcher"
#define MyAppVersion "1.0"
#define MyAppPublisher "Quantum Leap"
#define MyAppExeName "TimeZoneSwitcherApp.exe"

[Setup]
; Note: The AppId value uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
AppId={{b68c1fa2-b201-44b0-965c-c5e84fc05fcc}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
; Uncomment the following line to create an entry in Add/Remove Programs
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra
SolidCompression=yes
; Request administrator privileges
PrivilegesRequired=admin
; 使用正确的参数控制静默安装行为
DisableFinishedPage=yes
DisableReadyPage=yes
; 添加此行以解决用户区域警告
AlwaysUsePersonalGroup=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
; 移除过时的快速启动栏选项
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
Source: "bin\Release\net6.0-windows\win-x86\publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\Release\net6.0-windows\win-x86\publish\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
; 移除快速启动栏图标
;Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry]
; Add startup entry (optional)
;Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#MyAppName}"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletevalue

[Code]
function IsDotNetInstalled: Boolean;
var
  success: Boolean;
  dotNetStatus: Cardinal;
  resultCode: Integer;
begin
  success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Core\Setup\InstalledVersions\x86\sharedhost', 'Version', dotNetStatus);
  if not success then begin
    success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Core\Setup\InstalledVersions\x64\sharedhost', 'Version', dotNetStatus);
  end;
  
  if not success then begin
    success := Exec('dotnet', '--list-runtimes', '', SW_HIDE, ewWaitUntilTerminated, resultCode);
    if not success or (resultCode <> 0) then begin
      success := False;
    end;
  end;
  
  Result := success;
end;

function InitializeSetup(): Boolean;
var
  resultCode: Integer;
begin
  Result := True;
  
  // 如果是静默安装模式，跳过 .NET 检查
  if WizardSilent() then
    Exit;
  
  if not IsDotNetInstalled then begin
    if MsgBox('This application requires .NET 6.0 Runtime, but it was not detected on your system.' + #13#10 + 'Do you want to download and install .NET 6.0?', mbConfirmation, MB_YESNO) = IDYES then begin
      ShellExec('open', 'https://dotnet.microsoft.com/download/dotnet/6.0', '', '', SW_SHOWNORMAL, ewNoWait, resultCode);
      Result := False;
    end else begin
      Result := False;
    end;
  end;
end;

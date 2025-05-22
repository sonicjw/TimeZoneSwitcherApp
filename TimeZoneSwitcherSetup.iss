<<<<<<< HEAD
; Basic Information
#define MyAppName "Time Zone Switcher"
#define MyAppVersion "1.0"
#define MyAppPublisher "Quantum Leap"
#define MyAppExeName "TimeZoneSwitcherApp.exe"

[Setup]
; Note: The AppId value uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
AppId={{b68c1fa2-b201-44b0-965c-c5e84fc05fcc}}
=======
; 基本信息
#define MyAppName "Time Zone Switcher"
#define MyAppVersion "1.0"
#define MyAppPublisher "Your Name"
#define MyAppExeName "TimeZoneSwitcherApp.exe"

[Setup]
; 注意: AppId的值为单独标识此应用程序。
; 不要在其他安装程序中使用相同的AppId值。
AppId={{A1B2C3D4-E5F6-7890-A1B2-C3D4E5F67890}
>>>>>>> b4a4532 (Initial commit)
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
<<<<<<< HEAD
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
=======
; 取消下面一行的注释，以在"添加/删除程序"中创建一个条目
;UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma
SolidCompression=yes
; 请求管理员权限
PrivilegesRequired=admin
>>>>>>> b4a4532 (Initial commit)

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
<<<<<<< HEAD
; 移除过时的快速启动栏选项
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
=======
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
>>>>>>> b4a4532 (Initial commit)

[Files]
Source: "bin\Release\net6.0-windows\win-x86\publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "bin\Release\net6.0-windows\win-x86\publish\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
<<<<<<< HEAD
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
; 移除快速启动栏图标
;Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon
=======
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon
>>>>>>> b4a4532 (Initial commit)

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Registry]
<<<<<<< HEAD
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
=======
; 添加开机启动项（可选）
;Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#MyAppName}"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletevalue
>>>>>>> b4a4532 (Initial commit)

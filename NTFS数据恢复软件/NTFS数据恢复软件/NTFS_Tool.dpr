program NTFS_Tool;

uses
  Forms,
  uMain in 'uMain.pas' {MainForm},
  uScanThread in 'uScanThread.pas',
  uNTFS in 'uNTFS.pas',
  uRecoverThread in 'uRecoverThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

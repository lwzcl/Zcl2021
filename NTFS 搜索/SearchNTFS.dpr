program SearchNTFS;

uses
  Vcl.Forms,
  uMain.SearchNTFS in 'uMain.SearchNTFS.pas' {MainSearchNTFS},
  uSearchNTFS in 'uSearchNTFS.pas',
  uSearchGrid in 'uSearchGrid.pas',
  uShellPopupMenu in 'uShellPopupMenu.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainSearchNTFS, MainSearchNTFS);
  Application.Run;
end.

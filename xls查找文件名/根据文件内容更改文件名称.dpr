program 根据文件内容更改文件名称;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {main},
  UMyThread in 'UMyThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmain, main);
  Application.Run;
end.

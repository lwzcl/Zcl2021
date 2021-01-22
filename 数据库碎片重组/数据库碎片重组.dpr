program 数据库碎片重组;

uses
  Vcl.Forms,
  Umain in 'Umain.pas' {FMain},
  UmyThrear in 'UmyThrear.pas',
  UFrm_selectDisk in 'UFrm_selectDisk.pas' {Form1},
  UTofileThread in 'UTofileThread.pas',
  Ujixi in 'Ujixi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

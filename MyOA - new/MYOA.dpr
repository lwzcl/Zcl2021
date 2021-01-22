program MYOA;

uses
  Vcl.Forms,
  UFrm_Main in 'UFrm_Main.pas' {Frm_Main},
  UDM_XS in 'UDM_XS.pas' {DM_XS: TDataModule},
  UFrXSInfo in 'UFrXSInfo.pas' {Frm_XSInfo},
  UFrm_Find in 'UFrm_Find.pas' {Frm_Find},
  UFrm_PJAdd in 'UFrm_PJAdd.pas' {Frm_PJAdd},
  UitemTools in 'UitemTools.pas',
  UFrm_PJSelect in 'UFrm_PJSelect.pas' {Frm_PJselect},
  UFrm_CW in 'UFrm_CW.pas' {Frm_CW},
  UFrm_Login in 'UFrm_Login.pas' {Frm_Login},
  UrmKeHuInfo in 'UrmKeHuInfo.pas' {Frm_KhInfo},
  UFrm_kehu_find in 'UFrm_kehu_find.pas' {Frm_kehu_find},
  Urm_CgMain in 'Urm_CgMain.pas' {Frm_Cg_Main},
  Urm_cgInput in 'Urm_cgInput.pas' {Frm_cgInput},
  UFrm_cg_info in 'UFrm_cg_info.pas' {Frm_cg_info},
  UFrm_cg_add in 'UFrm_cg_add.pas' {Frm_cg_add};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM_XS, DM_XS);
  Application.CreateForm(TFrm_Main, Frm_Main);
  Application.Run;
end.
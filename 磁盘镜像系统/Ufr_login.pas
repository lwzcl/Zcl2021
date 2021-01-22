unit Ufr_login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scControls, scGPControls,
  scGPExtControls, Vcl.StdCtrls, Vcl.Mask, dxSkinsCore, dxSkinsDefaultPainters,
  cxClasses, cxLookAndFeels, dxSkinsForm;

type
  TFrm_login = class(TForm)
    scGPEdit1: TscGPEdit;
    scGPPasswordEdit1: TscGPPasswordEdit;
    scGPButton1: TscGPButton;
    dxSkinController1: TdxSkinController;
    scGPLabel1: TscGPLabel;
    procedure scGPButton1Click(Sender: TObject);
    procedure scGPLabel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_login: TFrm_login;

implementation

{$R *.dfm}
 uses
 Winapi.ShellAPI;
procedure TFrm_login.scGPButton1Click(Sender: TObject);
begin
    if scGPPasswordEdit1.Text <> 'zcl5201314' then
    begin
       Application.MessageBox('用户名或者密码有误！', '友情提示', MB_OK);
       exit;
    end;

  ModalResult := mrOk;
end;

procedure TFrm_login.scGPLabel1Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, nil, pchar('http://www.jssjhf.com/'), nil, nil, SW_SHOWNORMAL);
end;

end.

unit UFrm_Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scControls,
  scGPControls, Vcl.StdCtrls, Vcl.Mask, scGPExtControls, dxGDIPlusClasses,
  cxClasses, cxGraphics, Vcl.BaseImageCollection, Vcl.ImageCollection,
  System.ImageList, Vcl.ImgList;

type
  TFrm_Login = class(TForm)
    scGPPanel1: TscGPPanel;
    scGPLabel1: TscGPLabel;
    edit_UserName: TscGPEdit;
    scGPButton1: TscGPButton;
    scGPButton2: TscGPButton;
    edit_Password: TscGPPasswordEdit;
    procedure scGPButton1Click(Sender: TObject);
    procedure scGPButton2Click(Sender: TObject);
    procedure edit_PasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Login: TFrm_Login;

implementation

{$R *.dfm}
uses
  UDM_XS;

procedure TFrm_Login.edit_PasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key=13 then
      begin
          scGPButton1Click(Sender);
      end;
end;

procedure TFrm_Login.scGPButton1Click(Sender: TObject);
const
  vsql: string = 'SELECT * FROM UserInfo WHERE UserName = %s and UserPassword = %s';
var
  UserName, UserPassword, sqla: string;
begin
  UserName := Trim(edit_UserName.Text);
  UserPassword := edit_Password.Text;
  sqla := Format(vsql, [UserName.QuotedString, UserPassword.QuotedString]);
  with DM_XS.ADQ_user do
  begin
    Close;
    sql.Text := sqla;
    Open;
    if RecordCount = 0 then
    begin
       Application.MessageBox('�û���������������', '������ʾ', MB_OK);
       exit;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TFrm_Login.scGPButton2Click(Sender: TObject);
begin
  ModalResult := mrClose;
end;

end.

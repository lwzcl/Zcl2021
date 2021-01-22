unit UFrmSTratr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxProgressBar, UThread, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.Menus, cxButtons, uFrmMain;

type
  TFrmSTratr = class(TForm)
    Panel1: TPanel;
    cxProgressBar1: TcxProgressBar;
    lbl_item: TLabel;
    ActionList1: TActionList;
    act_start: TAction;
    act_stop: TAction;
    act_Continue: TAction;
    act_close: TAction;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    Timer1: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure act_startExecute(Sender: TObject);
    procedure act_stopExecute(Sender: TObject);
    procedure act_closeExecute(Sender: TObject);
    procedure act_ContinueExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    tmp :LONG64;
  public
    { Public declarations }
  end;

var
  FrmSTratr: TFrmSTratr;

var
  Work: Tword;

implementation

{$R *.dfm}
uses
  UdiskIo;

procedure TFrmSTratr.act_closeExecute(Sender: TObject);
begin

  Work.myState := True;
//  mywork.FreeOnTerminate := True;
  Work.FreeOnTerminate := True;
  Timer1.Enabled := False;

end;

procedure TFrmSTratr.act_ContinueExecute(Sender: TObject);
begin
  Work.Suspended := False;
  Timer1.Enabled := True;

end;

procedure TFrmSTratr.act_startExecute(Sender: TObject);
begin
  Work := Tword.Create(true);
  try
    Work.Start;

  except
    on E: Exception do
    begin
      ShowMessage('启动失败！');

    end;

  end;
end;

procedure TFrmSTratr.act_stopExecute(Sender: TObject);
begin
  Work.Suspended := True;
  Timer1.Enabled := False;

end;

procedure TFrmSTratr.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  case Application.MessageBox('您确定要停止？', '提示', MB_OKCANCEL) of
    IDOK:
      begin
        Work.myState := True;
        Work.FreeOnTerminate := True;
        CanClose := True;
      end;
    IDCANCEL:
      begin
        CanClose := False;
      end;
  end;

end;

procedure TFrmSTratr.FormCreate(Sender: TObject);
begin
    tmp := 0;
end;

procedure TFrmSTratr.Timer1Timer(Sender: TObject);
var
  kedu: LONG64;
  index: LONG64;

begin
  kedu := (StrToInt64(Form2.lbl_yuan_szie.Caption) * 512) div 100;
  index := Work.myjindu^;
  cxProgressBar1.Position := Integer(index div kedu);
  Form2.dxStatusBar1.Panels[3].Text := '每秒'+ ((index - tmp)div 1024 div 1024).ToString +'MB';
  tmp := index;
end;

end.


unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, System.Actions, Vcl.ActnList, dxBar,
  cxClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxBarBuiltInMenu, cxPC, Vcl.StdCtrls, Vcl.ExtCtrls, dxStatusBar, Vcl.Grids,
  Vcl.ComCtrls, dxSkinsForm, cxContainer, cxEdit, cxProgressBar, dxTabbedMDI,
  Winapi.ShellAPI, dxGDIPlusClasses, dxSkinOffice2019Colorful;

type
  TForm2 = class(TForm)
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    actlst_tools: TActionList;
    act_selectDisk1: TAction;
    act_selectDisk2: TAction;
    lbl_Yuan_Mode: TLabel;
    lbl_yuan_szie: TLabel;
    lbl_Yuan_prot: TLabel;
    lbl_Yuan_Sn: TLabel;
    lbl_MuBiao_Mode: TLabel;
    lbl_MuBiao_size: TLabel;
    lbl_MuBiao_prot: TLabel;
    lbl_MuBiao_SN: TLabel;
    Panel1: TPanel;
    dxBarLargeButton3: TdxBarLargeButton;
    act_ghost: TAction;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    act_Eecrypt: TAction;
    act_P_find: TAction;
    act_FindData: TAction;
    dxBarLargeButton7: TdxBarLargeButton;
    act_start_end: TAction;
    lbl_start: TLabel;
    lbl_end: TLabel;
    dxBarLargeButton8: TdxBarLargeButton;
    act_hddCheck: TAction;
    dxBarLargeButton9: TdxBarLargeButton;
    act_erase: TAction;
    dxBarButton1: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    dxStatusBar1: TdxStatusBar;
    tmr_jishi: TTimer;
    dxTabbedMDIManager1: TdxTabbedMDIManager;
    dxBarLargeButton10: TdxBarLargeButton;
    act_ToFile: TAction;
    SaveDialog1: TSaveDialog;
    tmr_time: TTimer;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarLargeButton13: TdxBarLargeButton;
    act_HDDRAID: TAction;
    act_About: TAction;
    Image1: TImage;
    cxImageCollection1: TcxImageCollection;
    cxImageCollection1Item1: TcxImageCollectionItem;
    dxSkinController1: TdxSkinController;
    procedure act_selectDisk1Execute(Sender: TObject);
    procedure act_selectDisk2Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure act_ghostExecute(Sender: TObject);
    procedure act_start_endExecute(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure tmr_jishiTimer(Sender: TObject);
    procedure act_EecryptExecute(Sender: TObject);
    procedure act_ToFileExecute(Sender: TObject);
    procedure tmr_timeTimer(Sender: TObject);
    procedure act_P_findExecute(Sender: TObject);
    procedure act_hddCheckExecute(Sender: TObject);
    procedure act_AboutExecute(Sender: TObject);
    procedure act_eraseExecute(Sender: TObject);
    procedure act_FindDataExecute(Sender: TObject);
    procedure act_HDDRAIDExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    isHdd: Boolean;

  public
    { Public declarations }
    StrarSec: LONG64;
    EndSec: LONG64;
    procedure startdemo();
    property myisHdd: Boolean read isHdd write isHdd;
    procedure bakgumIMG();

  end;

var
  Form2: TForm2;
  StartTime: TDateTime;

implementation

uses
  UFrm_selectDisk, UFrmstrart_end, UThread, UFrmSTratr, UFrm_ViewSector,
  UFrmToFile, UFrmFindPartition, UFrmCheck, UFrm_Erase, Winapi.GDIPAPI,
  Winapi.GDIPOBJ,UFrm_Raid;
{$R *.dfm}

procedure TForm2.act_selectDisk1Execute(Sender: TObject);
begin
  Form1 := TForm1.Create(self);
     //frmshangping := Tfrmshangping.Create(self);
  with Form1 do
  begin
    Form1.Caption := '选择故障磁盘';
    ShowModal;
    myisHdd := True;
    Free;
  end;
end;

procedure TForm2.act_selectDisk2Execute(Sender: TObject);
begin
  Form1 := TForm1.Create(self);
     //frmshangping := Tfrmshangping.Create(self);
  with Form1 do
  begin
    Form1.Caption := '选择目标磁盘';
    ShowModal;
    myisHdd := False;
    Free;
  end;
end;

procedure TForm2.act_AboutExecute(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, pchar('http://www.jssjhf.com/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.act_EecryptExecute(Sender: TObject);
begin
  if Form2.lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行主程序！', '提示', MB_OK);
    Exit;

  end;

  Frm_ViewSector := TFrm_ViewSector.Create(self);
  with Frm_ViewSector do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TForm2.act_eraseExecute(Sender: TObject);
begin
  if Form2.lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行主程序！', '提示', MB_OK);
    Exit;

  end
  else
  begin

    Frm_Erase := TFrm_Erase.Create(Application);
    with Frm_Erase do
    begin
      ShowModal;
      Frm_Erase.Free;
    end;

  end;
end;

procedure TForm2.act_FindDataExecute(Sender: TObject);
begin
  if Form2.lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行主程序！', '提示', MB_OK);
    Exit;

  end;

end;

procedure TForm2.act_ghostExecute(Sender: TObject);
begin

  if (lbl_Yuan_Mode.Caption = '') and (lbl_MuBiao_Mode.Caption = '') then
  begin
    Application.MessageBox('请选择磁盘后在开始启动！', '提示', MB_OK);
    Exit();

  end;
  if lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行此程序', '提示', MB_OK);

    exit;
  end;
  //TThread.CreateAnonymousThread(startdemo).Start;
  try
    try
      FrmSTratr := TFrmSTratr.Create(Application);
      with FrmSTratr do
      begin
        ShowModal;
        Free;
      end;
    except
      on E: Exception do
        ShowMessage(e.Message);
    end;
  finally

  end;

end;

procedure TForm2.act_hddCheckExecute(Sender: TObject);
begin
  if lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行主程序！', '提示', MB_OK);
    Exit;

  end;

  FrmCheck := TFrmCheck.Create(self);
  with FrmCheck do
  begin
    Show;

  end;
end;

procedure TForm2.act_HDDRAIDExecute(Sender: TObject);
begin

   Frm_Raid := TFrm_Raid.Create(Application);
   with Frm_Raid do
   begin
      Frm_Raid.Caption := '磁盘阵列计算';
     Frm_Raid.ShowModal;
     Frm_Raid.Free;
   end;

end;

procedure TForm2.act_P_findExecute(Sender: TObject);
begin
  if Form2.lbl_yuan_szie.Caption = '' then
  begin
    Application.MessageBox('请用管理员权限运行主程序！', '提示', MB_OK);
    Exit;

  end;

  FrmFindPartition := TFrmFindPartition.Create(Application);
  with FrmFindPartition do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TForm2.act_start_endExecute(Sender: TObject);
begin
  if (lbl_Yuan_Mode.Caption = '') and (lbl_MuBiao_Mode.Caption = '') then
  begin
    Application.MessageBox('请选择磁盘后在开始启动！', '提示', MB_OK);
    Exit();

  end;
  if (lbl_yuan_szie.Caption = '') and (lbl_MuBiao_size.Caption = '') then
  begin
    Application.MessageBox('请用管理员权限运行此程序', '提示', MB_OK);

    exit;
  end;
  Frmstrart_end := TFrmstrart_end.Create(self);
  with Frmstrart_end do
  begin
    edt_start.Text := '0';
    edt_end.Text := Form2.lbl_yuan_szie.Caption;
    Show;
    //Free;

  end;

end;

procedure TForm2.act_ToFileExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    dxStatusBar1.Panels[3].Text := SaveDialog1.FileName;
    myisHdd := True;

    SaveDialog1.Free;

  end;
end;
 //绘制背景

procedure TForm2.bakgumIMG();
var
  Graphics: TGPGraphics;
  Image: TGPImage;
begin
     //载入我们的图片文件
  Image := TGPImage.Create('.\bking.jpg');
     // 将载入的图片文件绘制到指定的组件上面
  Graphics := TGPGraphics.Create(Image1.Canvas.Handle);
     //绘制图片
  Graphics.DrawImage(Image, MakeRect(0, 0, self.Width, self.Height));
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  case Application.MessageBox('你确定要关闭程序吗？', '提示', MB_OKCANCEL) of
    IDOK:
      begin
        tmr_time.Enabled := False;
        CanClose := True;
      end;
    IDCANCEL:
      begin
        CanClose := false;
      end;
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  myisHdd := False;
  StrarSec := 0;
  EndSec := 0;

end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  Form2.Free;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  dxStatusBar1.Panels[0].Text := formatdatetime('yyyy" 年 "mm" 月 "dd" 日 "ddddhh":"mm":"ss"', now);
  dxStatusBar1.Panels[1].Text := '蓝网数据恢复中心欢迎你！电话：0519-85808818    网址：jssjhf.com';
  dxStatusBar1.Panels[4].Text := '手机（微信同手机号） 18112338818  15351913236';
  StartTime := Now;
     //tmr_jishi.Enabled := True;
  tmr_time.Enabled := True;

end;

procedure TForm2.startdemo;
begin

end;

procedure TForm2.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  FRect: TRect;
begin
  with (Sender as TStringGrid) do
  begin

    Canvas.Brush.Color := clGreen;

    //Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, cells[ACol, ARow]);
    //Canvas.FrameRect(Rect);
    Canvas.FrameRect(CellRect(ACol, ARow));

  end;
end;

procedure TForm2.tmr_jishiTimer(Sender: TObject);
var
  oktime: TDateTime;
begin
  tmr_jishi.Enabled := False;
  oktime := Now - StartTime;
  dxStatusBar1.Panels[2].Text := '已用时：' + FormatDateTime('hh:nn:ss', oktime);
  tmr_jishi.Enabled := True;
end;

procedure TForm2.tmr_timeTimer(Sender: TObject);
begin
  dxStatusBar1.Panels[0].Text := formatdatetime('yyyy" 年 "mm" 月 "dd" 日 "ddddhh":"mm":"ss"', now);
end;

end.


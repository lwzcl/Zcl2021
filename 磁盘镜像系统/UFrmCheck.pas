unit UFrmCheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.Grids, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dxSkinXmas2008Blue, uCheckered, Vcl.StdCtrls, cxButtons, System.Actions,
  Vcl.ActnList, cxControls, cxContainer, cxEdit, cxLabel, dxBarBuiltInMenu, cxPC,
  DateUtils, UmycheckThread, uMyGrid;

type
  TFrmCheck = class(TForm)
    Panel1: TPanel;
    cxButton1: TcxButton;
    ActionList1: TActionList;
    act_check: TAction;
    act_end: TAction;
    lb_Mode: TcxLabel;
    lb_SN: TcxLabel;
    lb_Size: TcxLabel;
    Panel2: TPanel;
    cxPageControl1: TcxPageControl;
    cxtbs1: TcxTabSheet;
    cxtbs2: TcxTabSheet;
    Memo1: TMemo;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    act_stop: TAction;
    act_conunt: TAction;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure act_checkExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure act_conuntExecute(Sender: TObject);
    procedure act_stopExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    C: TDataGrid;
    zhangtai: Boolean;
    procedure viesectitem();
  public
    { Public declarations }
    function hddcheck(hddno: string; hddsize: LONG64): Boolean;
    procedure Start();
    procedure droemygrid(index: LONG64);
    procedure OnClick(Sender: TObject; Index: UInt64);
  end;

var
  FrmCheck: TFrmCheck;
  mywork: mycheckThread;

implementation

{$R *.dfm}
uses
  uFrmMain;

procedure TFrmCheck.act_checkExecute(Sender: TObject);
begin
  mywork := mycheckThread.Create(true);
  try
    mywork.Start;

  except
    on E: Exception do
    begin
      ShowMessage('启动失败！');

    end;

  end;
end;

procedure TFrmCheck.act_conuntExecute(Sender: TObject);
begin

  myWork.Suspended := False;
  Timer1.Enabled := False;
end;



procedure TFrmCheck.act_stopExecute(Sender: TObject);
begin
  try
    mywork.Suspended := True;
    Timer1.Enabled := False;
  except
    on E: Exception do
      ShowMessage(e.Message);
  end;

end;

procedure TFrmCheck.droemygrid(index: LONG64);
begin

end;

procedure TFrmCheck.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   case Application.MessageBox('你确定要关闭程序吗？', '提示', MB_OKCANCEL) of
      IDOK:
        begin
          c.Free;
          CanClose := True;
        end;
      IDCANCEL:
        begin
          CanClose := false;
        end;
    end;



end;

procedure TFrmCheck.FormCreate(Sender: TObject);
var
  mysize: LongInt;
begin
  lb_Mode.Caption := '磁盘型号：' + Form2.lbl_Yuan_Mode.Caption;
  lb_SN.Caption := '序列号：' + Form2.lbl_Yuan_Sn.Caption;
  lb_Size.Caption := '磁盘容量：' + ((StrToInt64(Form2.lbl_yuan_szie.Caption)) div 1024 div 1024 div 2).ToString + 'GB';
  c := TDataGrid.Create(nil);
  c.Align := alLeft;
  c.Parent := cxtbs2;
  c.Width := 1610;
  mysize := StrToInt64(Form2.lbl_yuan_szie.Caption) div 100 div 16;
  c.RowCount := mysize;
  c.OnSmallClick := Self.OnClick;

  //C.RowCount(78140371);  //生成 500 行。每行100小格


end;

procedure TFrmCheck.FormDestroy(Sender: TObject);
begin
  FrmCheck.Free;
end;

procedure TFrmCheck.FormShow(Sender: TObject);
begin
     //dyuange :=  (StrToInt64(Form2.lbl_yuan_szie.Caption)) div 100;

end;

function TFrmCheck.hddcheck(hddno: string; hddsize: LONG64): Boolean;
begin

end;

procedure TFrmCheck.OnClick(Sender: TObject; Index: UInt64);
begin
  Showmessage('我是第 ' + Index.ToString + ' 个格子');
end;

procedure TFrmCheck.Start;
var
  Shddsize: LONG64;
  p: TBytes;
  index: LONG64;
  starTime: TTime;
  endTime: TTime;
  endsize: LONG64;
  kedu: LONG64;
  DeviceHandle: THandle;
  bak: Integer;
  zhangtai: Boolean;
  J: Integer;
  s: Integer;
begin
  try
    try
      bak := 8192;
      J := 0;
      zhangtai := True;
      Shddsize := StrToInt64(Form2.lbl_yuan_szie.Caption);
      index := StrToInt64(Form2.lbl_start.Caption);
      SetLength(p, 8192);
      endsize := StrToInt64(Form2.lbl_end.Caption);
      if endsize <= 0 then
      begin
        ShowMessage('请用管理员权限运行程序！');
        Memo1.Lines.Append('请用管理员权限运行程序！');
        Exit;
      end;
      kedu := (StrToInt64(Form2.lbl_yuan_szie.Caption)) div 100;
      DeviceHandle := CreateFile(PWideChar(Form2.lbl_Yuan_prot.Caption), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
        FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
      Memo1.Lines.Append('检测开始');
      Timer1.Enabled := True;
      if DeviceHandle <> INVALID_HANDLE_VALUE then
      begin
        while (index <= endsize div 16) do
        begin
          if zhangtai = False then
          begin
            Break;
          end;
          starTime := Now();
          FileSeek(DeviceHandle, index * bak, 0);
          FileRead(DeviceHandle, p[0], bak);
          endTime := Now();
          s := MilliSecondsBetween(endTime, starTime);   //时间
          if s <= 2 then
          begin
            C[index] := 1;

          end
          else if (s <= 3) and (s > 2) then
          begin
            C[index] := 3;
          end
          else if s > 4 then
          begin
            C[index] := 2;
          end;

          Inc(index);

        end;

      end;
    except
      on E: Exception do
    end;
  finally
    CloseHandle(DeviceHandle);
    Timer1.Enabled := False;
    Memo1.Lines.Append('检测结束');
  end;

end;

procedure TFrmCheck.Timer1Timer(Sender: TObject);
begin
  PostMessage(C.Handle, WM_VSCROLL,  SB_LINEDOWN , 0);
end;

procedure TFrmCheck.viesectitem;
begin

end;

end.


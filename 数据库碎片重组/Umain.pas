unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Colorful, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxProgressBar, cxClasses, dxSkinsForm, UmyThrear,
  Vcl.Menus;

type
  TFMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    But_SelectFile: TButton;
    Ed_filepath: TEdit;
    But_stop: TButton;
    But_checkDB: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cxProgressBar1: TcxProgressBar;
    FileOpenDialog1: TFileOpenDialog;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    ListView1: TListView;
    dxSkinController1: TdxSkinController;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    But_selectDisk: TButton;
    Timer2: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    sevdlg: TSaveDialog;
    procedure But_SelectFileClick(Sender: TObject);
    procedure But_GetVerivClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure But_checkDBClick(Sender: TObject);
    procedure But_repairClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure But_selectDiskClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    sevfile: string;
    function GetFileSize(const fName: AnsiString): Int64;
  public
    { Public declarations }

    function GetDatabaseVersion(): string;
    function DaraDatabaseVersion(v: integer): string;
    procedure ToFiledata();
    property mysevFile: string read sevfile write sevfile;
    procedure additem();
    procedure enddata();
  end;

type
  TRec = record
    index: LONG64;
    StartPage: LONG64;
    EndPage: LONG64;
    DatabaseName: string;
    DatabasePath: string;
    Status: string;
  end;

var
  FMain: TFMain;

  StartTime: TDateTime;

implementation

{$R *.dfm}
uses
  Winapi.ShellAPI, UFrm_selectDisk,Ujixi;
  var
   my_jixi : Mydatabases_jixi;


procedure TFMain.additem;
var
filename : string;
filesize : LONG64;
begin
    filename := StatusBar1.Panels[5].Text;
    filesize := StrToInt64( StatusBar1.Panels[2].Text);
     my_jixi.jiexi(filename,filesize);
end;

procedure TFMain.But_checkDBClick(Sender: TObject);
begin

  if FMain.StatusBar1.Panels[5].Text = '' then
  begin
    FMain.Memo1.Lines.Append('请选择要扫描的磁盘或者文件！');
    Exit;
  end;
  try
    StartTime := Now;
    Timer2.Enabled := True;
    Ed_filepath.Text := '正在执行碎片扫描！';
     TThread.CreateAnonymousThread(additem).Start;
     TThread.CreateAnonymousThread(enddata).Start;

  except
    on E: Exception do
      ShowMessage('启动失败！');
  end;
end;

procedure TFMain.But_GetVerivClick(Sender: TObject);
var
  Version: string;
begin
  Version := GetDatabaseVersion();
  ShowMessage(Version);

end;

procedure TFMain.But_repairClick(Sender: TObject);
begin
  ShowMessage('修复功能，请联系蓝网数据恢复中心授权 0519-85808818  18112338818');
end;

procedure TFMain.But_selectDiskClick(Sender: TObject);
begin

  Form1 := TForm1.Create(self);
     //frmshangping := Tfrmshangping.Create(self);
  with Form1 do
  begin
    Form1.Caption := '选择故障磁盘';
    ShowModal;
    Free;
  end;

end;

procedure TFMain.But_SelectFileClick(Sender: TObject);
var
  //mysize: LongInt;
  number: LONG64;
begin
//
  if FileOpenDialog1.Execute then
  begin

    StatusBar1.Panels[5].Text := FileOpenDialog1.FileName;
    number := GetFileSize(FileOpenDialog1.FileName);
    StatusBar1.Panels[2].Text := IntToStr(number div 512);
    StatusBar1.Panels[0].Text := FileOpenDialog1.FileName;

//    tmp:=  FileOpenDialog1.FileName;
//    number := pos('.MDF', tmp);   //判断有没有.mdf的文件
//    if number <= 0 then
//    begin
//      Application.MessageBox('请选择数据库文件！', '友情提醒', MB_OK);
//      Ed_filepath.Text := '';
//    end;
  end;

end;

function TFMain.DaraDatabaseVersion(v: integer): string;
begin
   //OK
  if v = 856 then
  begin
    Result := 'Server 2016'
  end
  else if v = 782 then
  begin
    Result := 'Server 2014'
  end
  else if v = 706 then
  begin
    Result := 'Server 2012'
  end
  else if v = 665 then
  begin
    Result := ' Server 2008 R2'
  end
  else if v = 661 then
  begin
    Result := 'Server 2008';
  end
  else if v = 611 then
  begin
    Result := 'Server 2005';
  end
  else if v = 539 then
  begin
    Result := 'Server 2000';
  end
  else if v = 515 then
  begin
    Result := 'Server 7';
  end
  else
  begin
    Result := '未知';
  end;

end;

procedure TFMain.enddata;
begin
    my_jixi.AddIDList();
end;

procedure TFMain.FormCreate(Sender: TObject);
begin

  my_jixi := Mydatabases_jixi.Create();
end;

function TFMain.GetDatabaseVersion: string;
var
  p: TBytes;
  filestr: TFileStream;
  bs: array[0..3] of Byte;
  number: Integer;
begin
  try
    SetLength(p, 512);
    filestr := TFileStream.Create(Trim(Ed_filepath.Text), fmOpenRead, fmShareDenyNone);
    filestr.Seek(144 * 512, soBeginning);
    filestr.Read(p, 512);
    CopyMemory(@bs[0], @p[100], 2);
    bs[2] := 0;
    bs[3] := 0;
    number := integer(bs);
    Result := DaraDatabaseVersion(number);
  finally
    filestr.Free;
//    FreeMemory(p);
  end;

end;

function TFMain.GetFileSize(const fName: AnsiString): Int64;
var
  hFile: THandle;
begin
  hFile := _lopen(PAnsiChar(fName), OF_READ);
  Result := FileSeek(hFile, Int64(0), 2);
  _lclose(hFile);

end;

procedure TFMain.Label1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, pchar('http://www.jssjhf.com/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TFMain.ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  i: Integer;
begin

  i := (Sender as TListView).Items.IndexOf(Item);
                                                 //clGradientActiveCaption
  if odd(i) then
    Sender.Canvas.Brush.Color := clGradientActiveCaption
  else
    Sender.Canvas.Brush.Color := clGradientInactiveCaption;

  Sender.Canvas.FillRect(Item.DisplayRect(drIcon));

end;



procedure TFMain.N1Click(Sender: TObject);
var
  QF1: Textfile;
begin
  if sevdlg.Execute then
  begin
    mysevFile := sevdlg.FileName + '.lw';
  end;
  if mysevFile = '' then
    Exit;

  TThread.CreateAnonymousThread(ToFiledata).Start;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
var
  index: LONG64;
  kedu: LONG64;
begin

  index := my_jixi.myjindu^;
  StatusBar1.Panels[3].Text := IntToStr(index div 512);

  kedu := (StrToInt64(StatusBar1.Panels[2].Text) * 512) div 100;
//  index := Work.myjindu^;
  cxProgressBar1.Position := Integer(index div kedu);
end;

procedure TFMain.Timer2Timer(Sender: TObject);
var
  oktime: TDateTime;
begin
  Timer2.Enabled := False;
  oktime := Now - StartTime;
  StatusBar1.Panels[4].Text := FormatDateTime('hh:nn:ss', oktime);
  Timer2.Enabled := True;
end;

procedure TFMain.ToFiledata;

begin


end;

end.


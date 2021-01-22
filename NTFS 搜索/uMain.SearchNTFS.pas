unit uMain.SearchNTFS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, uSearchGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.Grids, dxSkinsCore, dxSkinsDefaultPainters, cxClasses, cxLookAndFeels,
  dxSkinsForm, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinTheBezier, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue
  ;

const
  WM_MyGrid = WM_USER + 1;

type
  TMainSearchNTFS = class(TForm)
    StatusBar: TStatusBar;
    eSearchNTFS: TEdit;
    Tm: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    dxSkinController1: TdxSkinController;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TmTimer(Sender: TObject);
    procedure eSearchNTFSChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label2Click(Sender: TObject);
    procedure eSearchNTFSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FNTFS: TFDMemTable;
    FGrid: TDataGrid;
    FProcHand: NativeUInt;
    FPageSize: NativeUInt;
    procedure WM_MyGrid(var Message: TMessage); message WM_MyGrid;
    procedure WM_SysMenu(var Message: TWMMenuSelect);message WM_SYSCOMMAND;
    procedure OnPmClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainSearchNTFS: TMainSearchNTFS;
    FMenu: TMenuItem; //可键菜单复制

implementation

{$R *.dfm}

uses uSearchNTFS,  Winapi.ShellAPI
  ,IdGlobalProtocols, Winapi.PsAPI, System.Generics.Collections;



{ TMainSearchNTFS }

var
  {$IFDEF CPUx64}
  ArrWS: array[0..MaxWord*64] of UInt64;
  {$ELSE}
  ArrWS: array[0..MaxWord*32-1] of UInt64;
  {$EndIF}


procedure TMainSearchNTFS.TmTimer(Sender: TObject);

  //工作内存
  function TotalWS(): NativeUInt;
  var
    pmc: TProcessMemoryCounters;
  begin
    Result := 0;
    pmc.cb := SizeOf(pmc);
    if GetProcessMemoryInfo(FProcHand, @pmc, pmc.cb)then
      Result:= pmc.WorkingSetSize;
  end;
  //专用工作集
  function PrivateWS():UInt64;
  var
    i: UInt;
  begin
    Result:= 0;
    try
      if QueryWorkingSet(FProcHand, @ArrWS , SizeOf(ArrWS)) then begin
        for i := 1 to ArrWS [0]+1 do begin
        if ArrWS[i] and $100 = 0 then
          Inc(Result);
        end;
        Result:= Result * Self.FPageSize;
      end;
    except
    end;
  end;

var
  mSize: NativeUInt;
  Total, Private: String;
begin
  Private:= '';
  mSize:= TotalWS();
  Total:= Format('工作集:%.2fM ', [mSize/1024/1024]);

  mSize:= PrivateWS();
  if mSize>0 then begin
    Private:= Format('专用集:%.2fM', [mSize/1024/1024]);
  end;

  StatusBar.Panels.Items[0].Text:= Total+' '+Private;
end;


procedure TMainSearchNTFS.eSearchNTFSChange(Sender: TObject);
begin
//  FNTFS.Filtered:= False;
//  if eSearchNTFS.Text<>'' then begin
//    FNTFS.Filter:= 'FileName like '+QuotedStr('%'+eSearchNTFS.Text+'%');
//    FNTFS.Filtered:= True;
//  end;
//  FGrid.UpData();

end;

procedure TMainSearchNTFS.eSearchNTFSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if key = 13 then
begin
     FNTFS.Filtered:= False;
  if eSearchNTFS.Text<>'' then begin
    FNTFS.Filter:= 'FileName like '+QuotedStr('%'+eSearchNTFS.Text+'%');
    FNTFS.Filtered:= True;
  end;
  FGrid.UpData();
end

end;

procedure TMainSearchNTFS.FormCreate(Sender: TObject);
var
  Pid: DWORD;
  Si: TSystemInfo;
begin
  Self.Position:= poScreenCenter;

  eSearchNTFS.Enabled:= False;

  FMenu:= TMenuItem.Create(Self); //可键菜单复制
  FMenu.Caption:= '蓝网数据恢复';

  FMenu.OnClick := OnPmClick;

  FNTFS:= TFDMemTable.Create(nil);
  FNTFS.Close();
  FNTFS.FieldDefs.Clear();
  FNTFS.FieldDefs.BeginUpdate;
  FNTFS.FieldDefs.Add('FileName', ftString, MAX_PATH, False);
  FNTFS.FieldDefs.Add('FilePath', ftString, 2*MAX_PATH, False);
  //FNTFS.FieldDefs.Add('FileObj',  ftLargeint, 0, False);
  FNTFS.CreateDataSet();
  FNTFS.Fields[0].DisplayLabel:= '文件名';
  FNTFS.Fields[1].DisplayLabel:= '文件路径';
  //FNTFS.Fields[2].DisplayLabel:= '对象';
  FNTFS.DisableControls;

  //搜索
  FGrid:= TDataGrid.Create(nil);
  FGrid.Parent:= Self;
  FGrid.Align := TAlign.alClient;
  FGrid.AlignWithMargins:= True;
  FGrid.Margins.Left  := 2;
  FGrid.Margins.Right := 2;
  FGrid.Margins.Top   := 2;
  FGrid.Margins.Bottom:= 2;


//  FNTFS.EmptyView;
//  ASearch:= TSearchNTFS.Create(Self, FNTFS);
//  ASearch.Start;

  Pid:= GetCurrentProcessID();
  FProcHand:= OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);

  //获取系统页面大小
  GetSystemInfo(Si);
  FPageSize:= Si.dwPageSize;

end;

procedure TMainSearchNTFS.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture();
  PostMessage(Self.Handle, WM_SYSCOMMAND, SC_MOVE+HTCAPTION, 0);
end;

procedure TMainSearchNTFS.FormShow(Sender: TObject);
var
  Search: TSearchNTFS;
begin
  Search:= TSearchNTFS.Create(FNTFS);
  Search.Start;
end;


procedure TMainSearchNTFS.Label2Click(Sender: TObject);
begin
  Winapi.ShellAPI.ShellExecute(0, 'open', LPWSTR('http://jssjhf.com'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainSearchNTFS.OnPmClick(Sender: TObject);
begin
  Showmessage('');
end;

procedure TMainSearchNTFS.WM_MyGrid(var message: TMessage);
begin
  eSearchNTFS.Enabled:= True;
  FGrid.LoadData(FNTFS);
  Label1.Caption:= 'NTFS 磁盘搜索完成，共' + IntToStr(FNTFS.RecordCount) +'条，在下面编辑框可模糊查询';
end;

procedure TMainSearchNTFS.WM_SysMenu(var Message: TWMMenuSelect);
begin
   if Message.IDItem = 100 then
    ShowMessage('您选择了自己添加的菜单！')
    else
      inherited;
end;

end.

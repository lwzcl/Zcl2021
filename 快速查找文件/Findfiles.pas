unit Findfiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Colorful,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxClasses, cxLookAndFeels, dxSkinsForm,
  FireDAC.Comp.Client, uSearchGrid, Vcl.Menus;

const
  WM_MyGrid = WM_USER + 1;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CB_drive: TComboBox;
    Button1: TButton;
    eSearchNTFS: TEdit;
    dxSkinController1: TdxSkinController;
    CB_all: TCheckBox;
    StatusBar1: TStatusBar;
    Lab_start: TLabel;
    Label1: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure eSearchNTFSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure CB_driveChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FNTFS: TFDMemTable;
    FGrid: TDataGrid;
    FProcHand: NativeUInt;
    FPageSize: NativeUInt;
    procedure AddIDList();
    procedure WM_MyGrid(var Message: TMessage); message WM_MyGrid;
    procedure OnPmClick(Sender: TObject);
  public
    { Public declarations }
    procedure GetDiskType();
  end;

  PShellItem = ^TShellItem;

  TShellItem = record
    ID: Integer;
    UserName: string;
    TypeName: string;
  end;

var
  Form2: TForm2;
  FMenu: TMenuItem; //可键菜单复制

implementation

{$R *.dfm}
uses
  NTFS_Find, Data.DB, System.IOUtils, uSearchNTFS,Winapi.ShellAPI;

procedure TForm2.AddIDList();
var
  Search: TSearchNTFS;
begin
  Search := TSearchNTFS.Create(FNTFS);
  Search.Start;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin

  AddIDList();
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
    shellExecute(Application.Handle, nil, pchar('http://www.jssjhf.com/'), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.CB_driveChange(Sender: TObject);
begin
      CB_all.Checked := False;
end;

procedure TForm2.eSearchNTFSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if Key = 13 then
  begin
    FNTFS.Filtered := False;
    if eSearchNTFS.Text <> '' then
    begin
      FNTFS.Filter := 'FileName like ' + QuotedStr('%' + eSearchNTFS.Text + '%');
      FNTFS.Filtered := True;
    end;
    FGrid.UpData();
  end
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  Pid: DWORD;
  Si: TSystemInfo;
begin

  GetDiskType();
  Self.Position := poScreenCenter;

  eSearchNTFS.Enabled := False;

  FMenu := TMenuItem.Create(Self); //可键菜单复制
  FMenu.Caption := '蓝网数据恢复';

  FMenu.OnClick := OnPmClick;

  FNTFS := TFDMemTable.Create(nil);
  FNTFS.Close();
  FNTFS.FieldDefs.Clear();
  FNTFS.FieldDefs.BeginUpdate;
  FNTFS.FieldDefs.Add('FileName', ftString, MAX_PATH, False);
  FNTFS.FieldDefs.Add('FilePath', ftString, 2 * MAX_PATH, False);
  //FNTFS.FieldDefs.Add('FileObj',  ftLargeint, 0, False);
  FNTFS.CreateDataSet();
  FNTFS.Fields[0].DisplayLabel := '文件名';
  FNTFS.Fields[1].DisplayLabel := '文件路径';
  //FNTFS.Fields[2].DisplayLabel:= '对象';
  FNTFS.DisableControls;

   //搜索
  FGrid := TDataGrid.Create(nil);
  FGrid.Parent := Self;
  FGrid.Align := TAlign.alClient;
  FGrid.AlignWithMargins := True;
  FGrid.Margins.Left := 2;
  FGrid.Margins.Right := 2;
  FGrid.Margins.Top := 2;
  FGrid.Margins.Bottom := 2;

  Pid := GetCurrentProcessID();
  FProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, Pid);

  //获取系统页面大小
  GetSystemInfo(Si);
  FPageSize := Si.dwPageSize;

end;

procedure TForm2.GetDiskType;
var
  str: string;
  Drivers: Integer;
  driver: char;
  i, temp: integer;
  d1, d2, d3, d4: DWORD;
  ss: string;
begin

  ss := '';
  Drivers := GetLogicalDrives;
  temp := (1 and Drivers);
  for i := 0 to 26 do
  begin
    if temp = 1 then
    begin
      driver := char(i + integer('A'));
      str := driver;
      if (driver <> '') and (getdrivetype(pchar(str)) <> drive_cdrom) and (getdrivetype(pchar(str)) <> DRIVE_REMOVABLE) then  //这里可以修改 获取光盘 可移动磁盘
      begin
        GetDiskFreeSpace(pchar(str), d1, d2, d3, d4);
        CB_drive.Items.Add(str);

      end;
    end;
    Drivers := (Drivers shr 1);
    temp := (1 and Drivers);

  end;

end;

procedure TForm2.ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
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

procedure TForm2.OnPmClick(Sender: TObject);
begin
  Showmessage('');
end;

procedure TForm2.WM_MyGrid(var Message: TMessage);
begin
  eSearchNTFS.Enabled := True;
  FGrid.LoadData(FNTFS);
  Label1.Caption := 'NTFS 磁盘搜索完成，共' + IntToStr(FNTFS.RecordCount) + '条，在下面编辑框可模糊查询';
end;

end.


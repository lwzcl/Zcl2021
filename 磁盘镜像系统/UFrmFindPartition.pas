unit UFrmFindPartition;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.ExtCtrls, cxContainer, cxEdit,
  cxListView, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Menus, cxButtons,
  UmyFindPatThread, dxSkinOffice2019Colorful;

type
  TFrmFindPartition = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ActionList1: TActionList;
    act_stratr: TAction;
    act_stop: TAction;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Label1: TLabel;
    Label2: TLabel;
    btn_stop: TcxButton;
    btn_count: TcxButton;
    act_end: TAction;
    act_count: TAction;
    Label3: TLabel;
    ListView1: TListView;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure act_stratrExecute(Sender: TObject);
    procedure act_stopExecute(Sender: TObject);
    procedure act_countExecute(Sender: TObject);
    procedure act_endExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MyFindDiskP();
  end;

var
  FrmFindPartition: TFrmFindPartition;
  findPat: myFindPatThread;

implementation

{$R *.dfm}
uses
  uFrmMain, UdiskIo;

procedure TFrmFindPartition.act_countExecute(Sender: TObject);
begin
  findPat.Suspended := False;
end;

procedure TFrmFindPartition.act_endExecute(Sender: TObject);
begin
  findPat.FreeOnTerminate := True;
end;

procedure TFrmFindPartition.act_stopExecute(Sender: TObject);
begin
  findPat.Suspended := True;
end;

procedure TFrmFindPartition.act_stratrExecute(Sender: TObject);
begin
  findPat := myFindPatThread.Create(true);
  try
    findPat.Start;

  except
    on E: Exception do
    begin
      ShowMessage('启动失败！');

    end;

  end;

end;

procedure TFrmFindPartition.FormCreate(Sender: TObject);
begin
  with ListView1 do
  begin
    Columns.Add;
    Columns.Add;
    Columns.Add;
    ViewStyle := vsreport;
    GridLines := true;
    columns.items[0].caption := '分区容量';
    columns.items[1].caption := '起始扇区';
    columns.items[2].caption := '结束扇区';
    Columns.Items[0].Width := 200;
    Columns.Items[1].Width := 200;
    Columns.Items[2].Width := 350;
  end;
end;

procedure TFrmFindPartition.FormShow(Sender: TObject);
begin
  Label1.Caption := Form2.lbl_Yuan_Mode.Caption;
  Label2.Caption := Form2.lbl_Yuan_Sn.Caption;
end;

procedure TFrmFindPartition.MyFindDiskP;
var
  DeviceHandle: THandle;
  THDeviceHandle: THandleStream;
  index: LONG64;
  ReturnByte: TBytes;
  Hddsize: LONG64;
  bs: array[0..7] of Byte;
  i: LONG64;
  startsec: LONG64;
  endsec: LONG64;
  no: Integer;
begin
  DeviceHandle := CreateFile(PWideChar(Form2.lbl_Yuan_prot.Caption), GENERIC_READ or GENERIC_WRITE,  //如果只是读扇区,可以用GENERIC_READ
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  THDeviceHandle := THandleStream.Create(DeviceHandle);
  Hddsize := StrToInt64(Form2.lbl_yuan_szie.Caption);
  SetLength(ReturnByte, 512);
  no := 1;
  if RadioButton1.Checked = True then
    index := 0;
  if RadioButton2.Checked = True then
    index := Hddsize;
  while (index >= Hddsize) do
  begin
    
    THDeviceHandle.Seek(index, soBeginning);
    THDeviceHandle.Read(ReturnByte, 512);
    if (ReturnByte[0] = $EB) and (ReturnByte[1] = $52) and (ReturnByte[2] = $90) and (ReturnByte[3] = $4E) and (ReturnByte[510] = $55) and (ReturnByte[511] = $AA) then
    begin
      CopyMemory(@bs[0], @ReturnByte[40], 8);
      i := LONG64(bs);
      THDeviceHandle.Seek(index - i, soBeginning);
      THDeviceHandle.Read(ReturnByte, 512);

      if (ReturnByte[0] = $EB) and (ReturnByte[1] = $52) and (ReturnByte[2] = $90) then
      begin
        startsec := index - i;
        endsec := index;
        THDeviceHandle.Seek(startsec + 6291456, soBeginning);
        THDeviceHandle.Read(ReturnByte, 512);
        if (ReturnByte[0] = $46) and (ReturnByte[1] = $49) and (ReturnByte[2] = $4C) and (ReturnByte[3] = $45) then
        begin
          with listview1.items.add do
          begin
            caption := (i div 1024 div 1024 div 2).ToString;
            subitems.add(startsec.ToString);
            subitems.add(endsec.ToString);
          end;
          case Application.MessageBox('以上分区正确吗？', '提示', MB_OKCANCEL) of
            IDOK:
              begin
                index := index - i;
              end;
            IDCANCEL:
              begin

              end;
          end;
          Inc(no);
        end;

      end;

    end;
    Label3.Caption := index.ToString;

    Dec(index);
  end;

end;

end.


unit UFrm_kehu_find;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
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
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ExtCtrls, cxTextEdit, Vcl.Menus;

type
  TFrm_kehu_find = class(TForm)
    Panel1: TPanel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Ku_Name: TcxGridDBColumn;
    cxGrid1DBTableView1Ku_GongS: TcxGridDBColumn;
    cxGrid1DBTableView1Ku_Tie: TcxGridDBColumn;
    cxGrid1DBTableView1Ku_DateTime: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Panel2: TPanel;
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure datafind(mysql : string); //ģ�����ҷ���
  end;

var
  Frm_kehu_find: TFrm_kehu_find;

implementation
uses UDM_XS,UFrXSInfo,UrmKeHuInfo;
{$R *.dfm}

{ TFrm_kehu_find }
/// <summary>
/// ģ��������ƥ�������
/// </summary>
/// <param name="sql"></param>
procedure TFrm_kehu_find.cxGrid1DBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  var    i, J:Integer;
  var
  tmp :string;
begin
 if Caption = '�ͻ���ѯϵͳ' then
 begin
     with cxGrid1DBTableView1.Controller do
      begin
         for i:=0 to SelectedRowCount-1   do
         begin
         tmp := SelectedRows[i].Values[0];
          Frm_XSInfo.DBEdit1.Text := tmp;
          tmp := SelectedRows[i].Values[1];
          Frm_XSInfo.DBEdit2.Text := tmp;
          tmp := SelectedRows[i].Values[2];
          Frm_XSInfo.DBEdit3.Text :=  tmp;
          Close;
         end;

    end;
 end;

 end;
procedure TFrm_kehu_find.datafind(mysql: string);
begin
    with DM_XS.FDQ_kehu do
  begin
    Close;
    sql.Text := mysql;
    Open;
  end;
end;

procedure TFrm_kehu_find.FormShow(Sender: TObject);
var sql:string;
begin

  if Caption = '�ͻ���ѯϵͳ' then
  begin
     if Frm_XSInfo.DBEdit1.Text <> '' then
    begin
        sql := 'SELECT * FROM KuInfo where Ku_Name LIKE  ''%' + Trim(Frm_XSInfo.DBEdit1.Text) + '%''  ';
    end else if Frm_XSInfo.DBEdit3.Text <> '' then
    begin
        sql := 'SELECT * FROM KuInfo where  Ku_Tie LIKE  ''%' + Trim(Frm_XSInfo.DBEdit3.Text) + '%''  ';
    end else
    begin
        sql := 'SELECT * FROM KuInfo ';
    end;

   datafind(sql);

  end
  else
  begin

    datafind('SELECT * FROM KuInfo');
  end;
end;

procedure TFrm_kehu_find.N1Click(Sender: TObject);
begin
    //�޸�
     Frm_KhInfo:= TFrm_KhInfo.Create(Application);
     with Frm_KhInfo do
     begin
        DM_XS.FDQ_kehu.Edit;
        Self.Caption := '�ͻ���Ϣ�޸�';
       ShowModal;
       Free;
     end;
end;

procedure TFrm_kehu_find.N2Click(Sender: TObject);
begin
    DM_XS.FDQ_kehu.Delete;
end;

procedure TFrm_kehu_find.N3Click(Sender: TObject);
begin
   Frm_KhInfo:= TFrm_KhInfo.Create(self);
      with Frm_KhInfo do
      begin
        DM_XS.FDQ_kehu.Append;
        ShowModal;
        Free;
      end;
end;

end.
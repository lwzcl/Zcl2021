unit UFrm_cg_info;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
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
  cxGrid, Vcl.ExtCtrls, Vcl.Menus, cxContainer, cxTextEdit, Vcl.StdCtrls,
  cxButtons, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, scGPExtControls;

type
  TFrm_cg_info = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1cg_name: TcxGridDBColumn;
    cxGrid1DBTableView1cg_tile: TcxGridDBColumn;
    cxGrid1DBTableView1cg_gs: TcxGridDBColumn;
    cxGrid1DBTableView1cg_bz: TcxGridDBColumn;
    cxGrid1DBTableView1cg_addree: TcxGridDBColumn;
    scGPEdit1: TscGPEdit;
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function mysqlex(mysql: string): Boolean;
  end;

var
  Frm_cg_info: TFrm_cg_info;

implementation

uses UDM_XS, UFrm_cg_add, Urm_cgInput;
{$R *.dfm}

procedure TFrm_cg_info.cxButton1Click(Sender: TObject);
var
  tmp, mysql: string;
begin
  tmp := scGPEdit1.Text;
  if tmp = '' then
  begin
    Application.MessageBox('请输入要查询的条件！', '友情提醒', MB_OK);
    Exit();
  end;

  // mysql := 'SELECT * FROM cg_users where  cg_gs LIKE '%倚%'';
  mysql := 'select * from cg_users where cg_gs like %s';
  mysql := Format(mysql, [Quotedstr('%' + tmp + '%')]);

    try
      with DM_XS.FDQ_cgUser do
      begin
        Close;
        sql.Clear;
        sql.Text := mysql;
        Open;

      end;

    except
      on E: Exception do


  end;

end;

procedure TFrm_cg_info.cxButton2Click(Sender: TObject);
begin
  Frm_cg_add := TFrm_cg_add.Create(Application);
  with Frm_cg_add do
  begin
    DM_XS.FDQ_cgUser.Append;
    ShowModal;
    Free;
  end;
end;

procedure TFrm_cg_info.cxButton3Click(Sender: TObject);
begin

  Frm_cg_add := TFrm_cg_add.Create(Application);
  with Frm_cg_add do
  begin
    DM_XS.FDQ_cgUser.Edit;
    ShowModal;
    Free;
  end;

end;

procedure TFrm_cg_info.cxButton4Click(Sender: TObject);
begin
    case Application.MessageBox('请输入要查询的条件！', '友情提醒', MB_OKCANCEL) of
      IDOK:
        begin
           DM_XS.FDQ_cgUser.Delete;
        end;
      IDCANCEL:
        begin

        end;
    end;

end;

procedure TFrm_cg_info.cxGrid1DBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
   var    i, J:Integer;
  var
  tmp :string;
begin
  if Caption = '查找供应商' then
 begin
     with cxGrid1DBTableView1.Controller do
      begin
         for i:=0 to SelectedRowCount-1   do
         begin
         tmp := SelectedRows[i].Values[0];
          Frm_cgInput.scGPEd_name.Text := tmp;
          tmp := SelectedRows[i].Values[1];
          Frm_cgInput.scGPDBEdit1.Text := tmp;
          tmp := SelectedRows[i].Values[2];
          Frm_cgInput.scGPDBEdit2.Text :=  tmp;
          Close;
         end;

    end;
 end;

end;

procedure TFrm_cg_info.FormCreate(Sender: TObject);
var
mysql :string;
begin
  mysql := 'select * from cg_users ';


    try
      with DM_XS.FDQ_cgUser do
      begin
        Close;
        sql.Clear;
        sql.Text := mysql;
        Open;

      end;

    except
      on E: Exception do


  end;


end;

function TFrm_cg_info.mysqlex(mysql: string): Boolean;
begin

  try
    with DM_XS.FDQuery1 do
    begin
      Close;
      sql.Clear;
      sql.Text := mysql;
      Open;

    end;
    Result := True
  except
    on E: Exception do
      Result := False;
  end;
end;

end.

unit UFrm_PJSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxTextEdit, cxMaskEdit, cxSpinEdit,
  cxSpinButton, Vcl.Menus, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxButtons,
  cxClasses, dxGDIPlusClasses, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxGridCustomView, cxGrid, dxDateRanges, dxSkinOffice2019Colorful;

type
  TFrm_PJselect = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    Edit1: TEdit;
    ActionList1: TActionList;
    act_select: TAction;
    act_mod: TAction;
    act_del: TAction;
    ComboBox1: TComboBox;
    Image1: TImage;
    cxImageCollection1: TcxImageCollection;
    cxImageCollection1Item1: TcxImageCollectionItem;
    PM1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Pj_Type: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_Mode: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_Sn: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_size: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_Fw: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_Data: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_HeadNo: TcxGridDBColumn;
    cxGrid1DBTableView1Pj_dianBanNo: TcxGridDBColumn;
    procedure act_modExecute(Sender: TObject);
    procedure act_delExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_PJselect: TFrm_PJselect;

implementation

uses
  UDM_XS, UFrm_PJAdd;
{$R *.dfm}

procedure TFrm_PJselect.act_delExecute(Sender: TObject);
var
item : Integer;
begin

    if cxGrid1DBTableView1.Controller.FocusedRowIndex >=0 then

     begin
     case Application.MessageBox('您确定要删除这条记录吗？', '提示', MB_OKCANCEL +
       MB_ICONINFORMATION) of
       IDOK:
         begin
            DM_XS.ADQ_PJ.Delete;

         end;
       IDCANCEL:
         begin
              exit;
         end;
     end;


     end else
     begin
       Application.MessageBox('请选择要删除的数据！', '提示', MB_OK + MB_ICONINFORMATION);

     end;

end;

procedure TFrm_PJselect.act_modExecute(Sender: TObject);
begin
  Frm_PJAdd := TFrm_PJAdd.Create(Application);
  with Frm_PJAdd do
  begin
    Frm_PJAdd.Caption := '配件信息修改';
    DM_XS.ADQ_PJ.Edit;
    ShowModal;
    Free;
  end;
end;

end.


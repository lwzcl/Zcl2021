unit UFrm_Find;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.Menus, System.Actions, Vcl.ActnList, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  dxSkinXmas2008Blue, cxButtons, Vcl.ComCtrls, cxControls, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxTextEdit, dxGDIPlusClasses,
  dxDateRanges, dxSkinOffice2019Colorful;

type
  TFrm_Find = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ComboBox_Find: TComboBox;
    pm1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ActionList1: TActionList;
    act_RecOk: TAction;
    act_del: TAction;
    act_Money: TAction;
    cxButton1: TcxButton;
    btn_find: TcxButton;
    cxButton2: TcxButton;
    edt_find: TEdit;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    Image1: TImage;
    cxImageCollection1: TcxImageCollection;
    cxImageCollection1Item1: TcxImageCollectionItem;
    Label1: TLabel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1xs_No: TcxGridDBColumn;
    cxGrid1DBTableView1xs_name: TcxGridDBColumn;
    cxGrid1DBTableView1xs_gs: TcxGridDBColumn;
    cxGrid1DBTableView1xs_til: TcxGridDBColumn;
    cxGrid1DBTableView1xs_hddType: TcxGridDBColumn;
    cxGrid1DBTableView1xs_Moede: TcxGridDBColumn;
    cxGrid1DBTableView1xs_Sn: TcxGridDBColumn;
    cxGrid1DBTableView1xs_HddSzie: TcxGridDBColumn;
    cxGrid1DBTableView1xs_StartTime: TcxGridDBColumn;
    cxGrid1DBTableView1xs_EndTime: TcxGridDBColumn;
    cxGrid1DBTableView1xs_jiezhangTime: TcxGridDBColumn;
    cxGrid1DBTableView1xs_money: TcxGridDBColumn;
    cxGrid1DBTableView1xs_zhuangTai: TcxGridDBColumn;
    cxGrid1DBTableView1xs_BeiZhu: TcxGridDBColumn;
    find_numu: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    CheckBox1: TCheckBox;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox_FindChange(Sender: TObject);
    procedure act_RecOkExecute(Sender: TObject);
    procedure btn_findClick(Sender: TObject);
    procedure act_delExecute(Sender: TObject);
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure findsql(s: string);
    procedure quey_data(mysql: string);
  end;

var
  Frm_Find: TFrm_Find;

implementation

{$R *.dfm}
uses
  UDM_XS, UFrXSInfo;

procedure TFrm_Find.act_delExecute(Sender: TObject);
var
  tmp,mysql: string;
  J ,I : Integer;
begin
    I :=  cxGrid1DBTableView1.Controller.FocusedRowIndex ;
    //J := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
  ShowMessage(VarToStr(cxGrid1DBTableView1.DataController.GetValue(I, 0)));
   //mysql := 'UPDATE XiaoShouInfo SET xs_IsDel=0 WHERE xs_No = 2192 ' ;   //''' + Trim(edt_find.Text) + '''  ';
   mysql :=  'UPDATE XiaoShouInfo SET xs_IsDel=0 WHERE xs_No = ''' + VarToStr(cxGrid1DBTableView1.DataController.GetValue(I, 0)) + '''  ';                                           //''' + Trim(edt_find.Text) + '''  ';
  if cxGrid1DBTableView1.Controller.FocusedRowIndex >= 0 then
  begin
    case Application.MessageBox('你确定要删除此条记录吗？', '提示', MB_OKCANCEL + MB_ICONINFORMATION) of
      IDOK:
        begin
         with DM_XS.FDQuery1 do
         begin
           close;
           sql.Clear;
           sql.Add(mysql);
           ExecSQL;

         end;
        end;
      IDCANCEL:
        begin

        end;
    end;
  end
  else
  begin
    Application.MessageBox('请选中要删除的数据？', '提示', MB_OK + MB_ICONINFORMATION);

  end;
//


end;

procedure TFrm_Find.act_RecOkExecute(Sender: TObject);
begin
  Frm_XSInfo := TFrm_XSInfo.Create(Application);
  with Frm_XSInfo do
  begin
    DM_XS.FDQuery1.Edit;
    Frm_XSInfo.ShowModal;
    Frm_XSInfo.Free

  end;

end;

procedure TFrm_Find.btn_findClick(Sender: TObject);
var
  sql: string;
begin
  if ComboBox_Find.Text = '恢复中' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo where xs_zhuangTai =0 and xs_IsDel is null ';
  end
  else if ComboBox_Find.Text = '己结帐' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where xs_jiezhangTime is not null and xs_jiekuanren is not null and xs_zhuangTai =1 ';
  end
  else if ComboBox_Find.Text = '结帐人' then
  begin
    edt_find.Visible := True;
    if (edt_find.Text <> '') then
    begin
      sql := 'SELECT * FROM XiaoShouInfo where xs_jiekuanren = ''' + Trim(edt_find.Text) + ''' ';
    end
    else
    begin
      Application.MessageBox('请输入结帐人的名称！', '消息提示！', MB_OK);
      exit;
    end;

  end
  else if ComboBox_Find.Text = '支付宝' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where  xs_jiekeuantype =''支付宝'' ';
  end
  else if ComboBox_Find.Text = '现金' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where  xs_jiekeuantype =''现金'' ';
  end
  else if ComboBox_Find.Text = '微信' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where  xs_jiekeuantype =''微信'' ';
  end
  else if ComboBox_Find.Text = '对公' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where  xs_jiekeuantype =''对公'' ';
  end
  else if ComboBox_Find.Text = '己恢复' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo where xs_zhuangTai =1 '
  end
  else if ComboBox_Find.Text = '未结帐' then
  begin

    sql := 'SELECT * FROM XiaoShouInfo  where xs_jiekeuantype is  null and xs_jiezhangTime is null and xs_zhuangTai =1  and xs_EndTime is not null';
  end
  else if ComboBox_Find.Text = '未恢复' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where  xs_IsDel = 0';

  end
  else if ComboBox_Find.Text = '取数日期' then
  begin
    Application.MessageBox('取数日期', '提示', MB_OK + MB_ICONINFORMATION);
  end
  else if ComboBox_Find.Text = '送修日期' then
  begin
    Application.MessageBox('送修日期', '提示', MB_OK + MB_ICONINFORMATION);
  end
  else if ComboBox_Find.Text = '客户公司' then
  begin
    edt_find.Visible := True;
    if CheckBox1.Checked = False then
    begin
       sql := 'SELECT * FROM XiaoShouInfo where xs_gs =''' + Trim(edt_find.Text) + ''' and  xs_jiekuanren is null and xs_jiekeuantype is null and xs_IsDel is null ';
    end else
    begin
      sql := 'SELECT * FROM XiaoShouInfo where xs_gs =''' + Trim(edt_find.Text) + '''  ';
    end;

  end
  else if ComboBox_Find.Text = '客户姓名' then
  begin
    edt_find.Visible := True;
    if CheckBox1.Checked = False then
    begin
       //sql := 'select * from  XiaoShouInfo where xs_name = ''' + Trim(edt_find.Text) + '''and  xs_jiekuanren is null and xs_jiekeuantype is null and xs_IsDel is null';
       sql :=   'select * from  XiaoShouInfo where xs_name like %s and xs_jiekuanren is null and xs_jiekeuantype is null and xs_IsDel is null';
       sql :=    Format(sql, [Quotedstr('%' + Trim(edt_find.Text) + '%')]);
    end else
    begin
       //sql := 'SELECT * FROM XiaoShouInfo where xs_name = like ''+%+' + Trim(edt_find.Text) + '''';
       sql :=   'select * from XiaoShouInfo where xs_name like %s';
       sql := Format(sql, [Quotedstr('%' + Trim(edt_find.Text) + '%')]);
       //LIKE ‘%三%’
       //mysql := 'select * from cg_users where cg_gs like %s';
        // mysql := Format(mysql, [Quotedstr('%' + Trim(Edit1.Text) + '%')]);
    end;

  end
  else if ComboBox_Find.Text = '全部' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo';
  end
  else if ComboBox_Find.Text = '未取数据' then
  begin
    sql := 'SELECT * FROM XiaoShouInfo  where xs_jiekeuantype is  null and xs_jiezhangTime is null and xs_zhuangTai =1  and xs_EndTime is null';
  end;

  try
    quey_data(sql);
  except
    on E: Exception do
      Application.MessageBox('提示', '出错了！', MB_OK);
  end;

end;

procedure TFrm_Find.ComboBox_FindChange(Sender: TObject);
begin

  if ComboBox_Find.Text = '结帐人' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入结帐人的姓名！';
  end
  else if ComboBox_Find.Text = '客户姓名' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入客户的姓名！';
  end
  else if ComboBox_Find.Text = '客户公司' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入客户的公司名称！';
  end
  else if ComboBox_Find.Text = '送修日期' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入送修日期！';
  end
  else if ComboBox_Find.Text = '取数日期' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入取数日期！';
  end
  else if ComboBox_Find.Text = '结帐日期' then
  begin
    edt_find.Visible := True;
    Label1.Visible := True;
    Label1.Caption := '请输入结帐日期！';
  end
  else
  begin
    edt_find.Visible := False;
    Label1.Caption := '';
    Label1.Visible := False;
  end;

end;

procedure TFrm_Find.cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
  var    I, J:Integer;
begin
   //for I:=0 to cxGrid1DBTableView1.DataController.GetSelectedCount - 1 do
//   J := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
//  ShowMessage(VarToStr(cxGrid1DBTableView1.DataController.GetValue(J, 0)));
end;

procedure TFrm_Find.DBGrid1CellClick(Column: TColumn);
begin
//    DBGrid1.Options := DBGrid1.Options + [dgRowSelect];
end;

procedure TFrm_Find.DBGrid1TitleClick(Column: TColumn);
begin
  Application.MessageBox('这里', '');
end;

procedure TFrm_Find.findsql(s: string);
const
  vsql: string = 'select * from xiaoshouinfo where xs_name like %s';
  vsql2: string = 'select  * from xiaoshouinfo';
var
  mysql: string;
begin
  if s.Trim.IsEmpty then
    mysql := vsql2
  else
    mysql := Format(vsql, [Quotedstr('%' + s + '%')]);
  with DM_XS.FDQuery1 do
  begin
    Close;
    sql.Text := mysql;
    Open;
  end;

end;

procedure TFrm_Find.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
      Self.Free;

end;

procedure TFrm_Find.FormCreate(Sender: TObject);
const
  mysql: string = 'SELECT * FROM XiaoShouInfo where xs_zhuangTai = 0 and xs_IsDel is null';
begin

  quey_data(mysql);
end;

procedure TFrm_Find.N4Click(Sender: TObject);
begin
     //TFrm_Find.btn_findClick();
end;

procedure TFrm_Find.quey_data(mysql: string);
begin
  with DM_XS.FDQuery1 do
  begin
    Close;
    SQL.Clear ;
    sql.Text := mysql;
    Open;
  end;
end;

end.


unit Urm_cgInput;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scControls, scGPControls, scCalendar,
  scDBControls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, scGPExtControls,
  scGPDBControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
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
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxButtons;

type
  TFrm_cgInput = class(TForm)
    scGPEd_name: TscGPDBEdit;
    Panel1: TPanel;
    scGPDBEdit1: TscGPDBEdit;
    scGPDBEdit2: TscGPDBEdit;
    scGPDBEdit3: TscGPDBEdit;
    scGPDBEdit4: TscGPDBEdit;
    scGPDBEdit5: TscGPDBEdit;
    scGPDBEdit6: TscGPDBEdit;
    scGPDBEdit8: TscGPDBEdit;
    scDBDateEdit1: TscDBDateEdit;
    scDBDateEdit2: TscDBDateEdit;
    scGPButton1: TscGPButton;
    scGPButton2: TscGPButton;
    scGPDBEdit7: TscGPDBEdit;
    cxButton1: TcxButton;
    procedure scGPButton1Click(Sender: TObject);
    procedure scGPButton2Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure clearitem(frm : TForm );
  public
    { Public declarations }
  end;

var
  Frm_cgInput: TFrm_cgInput;

implementation

uses UDM_XS, UFrm_cg_info;
{$R *.dfm}

procedure TFrm_cgInput.clearitem(frm : TForm );
var

  i: integer;
begin

  for i := 0 to frm.ControlCount - 1 do

    if Controls[i] is TscGPEdit then

      Tedit(Controls[i]).Clear;

      //Tedit(Controls[i]).Text:='';   也可

end;

procedure TFrm_cgInput.cxButton1Click(Sender: TObject);

begin

  Frm_cg_info := TFrm_cg_info.Create(Application);
  with Frm_cg_info do
  begin
    Caption := '查找供应商';
    ShowModal;
    Free;
  end;

end;

procedure TFrm_cgInput.scGPButton1Click(Sender: TObject);
var
i: integer;
begin
  // 提交
  if (scGPEd_name.Text <> '') and (scGPDBEdit1.Text <> '') and
    (scGPDBEdit2.Text <> '') then
  begin
    case Application.MessageBox('请确定要此操作！', '友情提醒', MB_OKCANCEL) of
      IDOK:
        begin
          DM_XS.FDQ_cg.Post;
        end;
      IDCANCEL:
        begin

            Exit;

        end;
    end;

  end;

  //clearitem(Frm_cgInput);
end;

procedure TFrm_cgInput.scGPButton2Click(Sender: TObject);
begin
  // 取消
  Close();
end;

end.

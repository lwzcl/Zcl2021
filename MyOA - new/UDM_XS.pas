unit UDM_XS;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Data.DBXDataSnap,
  Data.DBXCommon, IPPeerClient, Data.SqlExpr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDM_XS = class(TDataModule)
    ADC_XS: TADOConnection;
    DataSource_XS: TDataSource;
    ADQ_PJ: TADOQuery;
    DataSource_PJ: TDataSource;
    DataSource_CW: TDataSource;
    ADQ_user: TADOQuery;
    DataSource_kehu: TDataSource;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDQ_kehu: TFDQuery;
    FDQ_hdd: TFDQuery;
    FDQ_Cw: TFDQuery;
    FDQ_cg: TFDQuery;
    DataSource_cg: TDataSource;
    FDQ_cgUser: TFDQuery;
    DataSource_cg_User: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_XS: TDM_XS;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM_XS.DataModuleCreate(Sender: TObject);
begin
    if ADC_XS.Connected = False then

    begin
        ADC_XS.Connected := True;
    end;
    if FDConnection1.Connected = False then
    begin
      FDConnection1.Connected := True;
    end;
end;

end.
